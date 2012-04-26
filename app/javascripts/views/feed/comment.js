Radium.CommentView = Ember.View.extend({
  tagName: 'li',
  didInsertElement: function() {
    this.$('span.time').timeago();
  },
  templateName: 'comment'
});