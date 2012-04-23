Radium.InlineCommentsView = Ember.View.extend({
  templateName: 'inline_comments',
  isVisibleBinding: 'parentView.isCommentsVisible',
  contentBinding: 'parentView.content.comments'
});