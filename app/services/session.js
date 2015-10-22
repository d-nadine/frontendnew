import Ember from 'ember';
import User from 'radium/models/user';

const {
  Service
} = Ember;

export default Service.extend({
  setup() {
    return new Ember.RSVP.Promise((resolve) => {
      const authManager = this.get('authManager');

      User.find({name: 'me'}).then((records) => {
        const user = records.get('firstObject');

        if(window.Intercom) {
          window.Intercom("boot", {
            app_id: window.INTERCOM_APP_ID,
            email: user.get('email'),
            user_id: user.get('id'),
            created_at: user.get('createdAt').toUnixTimestamp(),
            widget: {
              activator: "#IntercomDefaultWidget"
            },
            increments: {
              number_of_clicks: 1
            }
          });
        }

        if(user.get('refreshFailed')) {
          return authManager.logOut();
        }

        Ember.$('.main-loading').hide();

        const registry = window.Radium.registry;

        registry.register('current:user', user, {instantiate: false, singleton: true});

        registry.injection('component', 'currentUser', 'current:user');
        registry.injection('controller', 'currentUser', 'current:user');
        registry.injection('route', 'currentUser', 'current:user');

        return resolve(user);
      });
    });
  },

  authManager: Ember.inject.service()
});

