import Ember from 'ember';

const {
  Service,
  A: emberArray
} = Ember;

export default Service.extend({
  init() {
    this.set('users', emberArray());
  },

  refresh() {
    Radium.User.find({}).then((results) => {
      this.set('users', results);

      this.notifyPropertyChange('users');
    });
  },

  getUsers: Ember.computed('users', function() {
    return this.get('users');
  })
});
