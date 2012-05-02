Radium.InlineTextArea = Ember.View.extend({
  tagName: 'span',
  templateName: 'inline_textarea',
  attributeBindings: ['title'],
  title: "Click to edit",
  isEditing: false,
  _cachedValue: null,

  click: function(event) {
    this.set('_cachedValue', this.get('value'));
    this.set('isEditing', true);
    this.$('textarea').focus();
  },
  keyUp: function(event) {
    event.preventDefault();
    if (event.keyCode === 13) {
      this.set('isEditing', false);
      event.stopPropagation();
      Radium.store.commit();
    }
    if (event.keyCode === 27) {
      this.set('value', this.get('_cachedValue'));
      this.set('isEditing', false);
    }
  },
  inlineEditTextArea: Ember.TextArea.extend({
    didInsertElement: function() {
      this._super();
      this.$().focus();
    },
    insertNewline: function(event) {
      console.log('hi');
      event.preventDefault();
      return false;
    }
  })
});