Radium.InlineSelect = Ember.View.extend({
  tagName: 'span',
  templateName: 'inline_select',
  isEditing: false,
  click: function(event) {
    this.set('isEditing', true);
    this.$('textarea').focus();
  },
  inlineSelectView: Ember.Select.extend({
    change: function() {
      this.setPath('parentView.isEditing', false);
    }
  })
});