import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
classNameBindings: ['isEditing:inline-editor-open', ':editor'],
  isEditing: false,
  isSaving: false,
  isSubmitted: false,
  isInvalid: false,
  errorMessages: Ember.A(),

  _setup: Ember.on('didInsertElement', function() {
    this._super(...arguments);

    $(document).on('click.inline', (e) => {
      if (!this.get('isEditing')) {
        return undefined;
      }

      const target = $(e.target);
      const tagName = e.target.tagName.toLowerCase();

      if (['x-check', 'new-comment', 'address-switcher'].any(function(c) {
        return target.hasClass(c);
      })) {
        return undefined;
      }

      if (tagName === "input" && ['radio', 'checkbox'].contains(target.attr('type'))) {
        return undefined;
      }

      if ((!['input', 'button', 'select', 'i', 'a'].contains(tagName)) || target.hasClass('resource-name')) {
        this.send('stopEditing');
        return undefined;
      }

      if(tagName === 'a' && (e.target && e.target === "_blank")) {
        return undefined;
      }

      e.preventDefault();
      e.stopPropagation();

      return false;
    });
  }),

  _teardown: Ember.on('willDestroyElement', function() {
    this._super(...arguments);

    $(document).off('click.inline');
  }),
  stopPropagation: function(e) {
    e.stopPropagation();
    e.preventDefault();
    return false;
  },
  click: function(e) {
    if (!this.get('isEditing')) {
      this.set('isEditing', true);
      this.send('startEditing');
      return this.stopPropagation(e);
    }
  }
});