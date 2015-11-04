import Ember from 'ember';
import ColumnsConfig from 'radium/mixins/conversations-columns-config';
import CommonDrawerActions from 'radium/mixins/common-drawer-actions';

const {
  Component,
  inject,
  computed,
  on
} = Ember;

export default Component.extend(ColumnsConfig, CommonDrawerActions, {
  actions: {
    updateTotals() {
      Radium.ConversationsTotals.find({}).then((results) => {
        const totals = results.get('firstObject');

        this.set('incoming', totals.get('incoming'));
        this.set('waiting', totals.get('waiting'));
        this.set('later', totals.get('later'));
        this.set('allUsersTotals', totals.get('allUsersTotals'));
        this.set('usersTotals', totals.get('usersTotals'));
        this.set('sharedTotals', totals.get('sharedTotals'));
        this.set('totalsLoading', false);
      });
    }
  },

  classNames: ['conversations-view'],

  _initialize: on('init', function() {
    this._super(...arguments);

    this.send('updateTotals');
  }),

  isIncoming: computed.equal("conversationType", "incoming"),
  isWaiting: Ember.computed.equal("conversationType", "waiting"),
  isLater: Ember.computed.equal("conversationType", "later"),
  isReplied: Ember.computed.equal("conversationType", "replied"),
  isArchived: Ember.computed.equal("conversationType", "archived"),
  isIgnored: computed.equal("conversationType", "ignored"),

  team: computed('users.users.[]', function(){
    return this.get('users.users').toArray().reject((user) => {
      return user === this.get('currentUser');
    });
  }),

  users: inject.service()
});
