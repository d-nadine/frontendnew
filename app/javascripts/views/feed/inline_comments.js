Radium.InlineCommentsView = Ember.View.extend({
  templateName: 'inline_comments',
  isVisibleBinding: 'parentView.isCommentsVisible',
  contentBinding: 'parentView.content.comments',
  comment: "",
  commentTextArea: Ember.TextArea.extend({
    placeholder: "Add a comment",
    valueBinding: 'comment'
  }),
  addComment: function() {
    if (this.get('comment')) {     
      console.log('add');
    } else {
      console.log('cannot add blank comments');
    }
  }
});