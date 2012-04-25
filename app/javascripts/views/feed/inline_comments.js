Radium.InlineCommentsView = Ember.View.extend({
  templateName: 'inline_comments',
  isVisibleBinding: 'parentView.isCommentsVisible',

  commentBinding: 'controller.newComment',
  commentTextArea: Ember.TextArea.extend({
    placeholder: "Add a comment",
    valueBinding: 'parentView.comment',
    classNameBindings: ['parentView.controller.isError:error'],
    didInsertElement: function() {
      this._super();
      this.$().focus();
    }

  }),

  addCommentButton: Ember.Button.extend({
    classNames: 'btn btn-small'.w(),
    action: 'addComment',
    target: 'parentView.controller',
    disabled: function() {
      return (this.getPath('parentView.comment') === '') ? true : false;
    }.property('parentView.comment')
  })
});