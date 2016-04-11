import Ember from 'ember';

export default Ember.Controller.extend({
  usersService: Ember.inject.service('users'),
  //needs: ['users', 'contacts', 'companies', 'accountSettings', 'contactStatuses'],
  loadedPages: [1],
  showDeleteConfirmation: false,
  isEditing: false,
  users: Ember.computed.oneWay('usersService.getUsers'),

  userIsCurrentUser: Ember.computed('model', 'currentUser', function() {
    return this.get('model') === this.get('currentUser');
  }),

  currentMonth: Ember.computed(function() {
    return Ember.DateTime.create().toFormattedString('%B');
  }),

  canDelete: Ember.computed('userIsCurrentUser', 'currentUser.isAdmin', function() {
    return !this.get('userIsCurrentUser') && this.get('currentUser.isAdmin');
  }),

  actions: {
    confirmDeletion() {
      this.set("showDeleteConfirmation", true);
      return false;
    },
    saveEmail(form) {
      this._super.call(this, form, {
        dontTransition: true
      });
      return false;
    }
  },
});
