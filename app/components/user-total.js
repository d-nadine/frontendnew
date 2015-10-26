import Ember from 'ember';

const {
  computed,
  on,
  Component
} = Ember;

export default Component.extend({
  actions: {
    showUserRecords: function() {
      this.attrs.showUserRecords(this.get('user'), this.get('query'));
    }
  },

  classNameBindings: [':item', ':user-item', 'isCurrent:active'],

  attributeBindings: ['userTotalId:user-data-id'],

  userTotalId: computed('isShared', 'userTotal.id', function() {
    if (this.get('isShared')) {
      return null;
    }

    return this.get('userTotal.id');
  }),

  user: computed('userTotal.id', function() {
    return Radium.User.all().find((u) => {
      return u.get('id') === this.get('userTotal.id').toString();
    });
  }),

  isCurrent: computed('parent.conversationType', 'user.id', function() {
    const parent = this.get('parent');
    return parent.get('conversationType') === this.get('query') && parent.get('user') === this.get('user.id');
  }),

  _setup: on('didInsertElement', function() {
    this._super(...arguments);

    return this.$('.who').tooltip();
  }),

  _teardown: on('willDestroyElement', function() {
    this._super(...arguments);

    const el = this.$('.who');

    if (el.data('tooltip')) {
      el.tooltip('destroy');
    }})
});
