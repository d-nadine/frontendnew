Radium.CommentView = Ember.View.extend({
  tagName: 'li',
  didInsertElement: function() {
    this.$('small.time').timeago();
  },
  templateName: 'comment'
});