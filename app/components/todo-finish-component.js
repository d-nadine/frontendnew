import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'button',
  classNameBindings: ["isFinished", ":btn", ":btn-link", ":pull-left", ":events-list-item-button", ":finish-todo"],
  attributeBindings: 'title',
  setup: Ember.on('didInsertElement', function() {
    // this._super.apply(this, arguments); //*** Will need later
    this.set('register-as', this);
    if (!this.get('parent.isNew')) {
      return this.$().tooltip();
    }
  }),
  teardown: Ember.on('willDestroyElement', function() {
    this._super.apply(this, arguments);
    if (this.$().data('tooltip')) {
      return this.$().tooltip('destroy');
    }
  }),
  click: function() {
    this.get('parent').triggerAction({
      action: 'finishTask'
    });
    return false;
  },
  title: Ember.computed('parent.isDisabled', 'parent.isFinished', function() {
    if (this.get('parent.isFinished')) {
      return "Mark as not done";
    } else {
      return "Mark as done";
    }
  })
});