import Ember from 'ember';

const {
  Component,
  inject,
  computed,
  on
} = Ember;

export default Component.extend({
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

  team: computed('users.users.[]', function(){
    return this.get('users.users').toArray().reject((user) => {
      return user === this.get('currentUser');
    });
  }),

  users: inject.service()
});
