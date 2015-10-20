import Ember from 'ember';
import User from "radium/models/user";
import d from "radium/utils/date-time";
import ENV from 'radium/config/environment';

export function initialize(container, application) {
  const authManager = container.lookup('service:authManager');

  application.deferReadiness();

  User.find({name: 'me'}).then((records) => {
    const user = records.get('firstObject');

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

    if(user.get('refreshFailed')) {
      const store = container.lookup('store:main');

      Ember.assert('you need a store in the container of the auth initializer", store');

      const apiUrl = store.get('_adapter.url');

      return authManager.logOut(apiUrl, `${apiUrl}/sessions/new`);
    }

    Ember.$('.main-loading').hide();

    application.advanceReadiness();

    if(ENV.environment !== "production" || location.pathname !== "/") {
      return;
    }

    Ember.run.next(() => {
      const router = container.lookup('router:main');
      router.replaceWith('people.contacts');
    });
  });
}

export default {
  name: 'auth',
  initialize: initialize,
  after: 'load-services'
};
