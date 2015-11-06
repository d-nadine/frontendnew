import Ember from 'ember';
import CommonDrawerActions from 'radium/mixins/common-drawer-actions';
import SaveContactActions from 'radium/mixins/save-contact-actions';

const {
  Component,
  inject
} = Ember;

export default Component.extend(SaveContactActions, CommonDrawerActions, {
  actions: {
    createList(list) {
      this.sendAction('createList', list, this.get('contact'));
    },

    addList(list) {
      this._super(this.get('contact'), list);
    },

    removeList(list) {
      this._super(this.get('contact'), list);
    },

    switchShared() {
      Ember.run.next(() => {
        const contact = this.get('contact');
        contact.toggleProperty('isPublic');

        if(!contact.get('isPublic')) {
          contact.set('potentialShare', true);
        }

        contact.save().then(() => {
          // FIXME: updateTotals

          if(contact.get('isUpdating')) {
            this.sendAction('startPolling');
          }
        });
      });
    },

    showCompany(contact) {
      const company = contact.get('company');

      this.send("showCompanyDrawer", company);
    }
  },

  lists: inject.service(),

  lassNameBindings: [':form'],

  shared: false,
  isSaving: false,
  condense: false,

  _initialize: Ember.on('init', function() {
    this._super(...arguments);

    this.set('shared', this.get('contact.isLoaded'));
  })
});
