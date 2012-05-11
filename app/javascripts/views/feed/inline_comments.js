Radium.InlineCommentsView = Ember.View.extend({
  templateName: 'inline_comments',
  isVisibleBinding: 'parentView.isCommentsVisible',
  commentBinding: 'controller.newComment',

  commentTextArea: Ember.TextArea.extend(Ember.TargetActionSupport, {
    placeholder: "Add a comment",
    valueBinding: 'parentView.comment',
    classNameBindings: ['parentView.controller.isError:error'],
    action: 'addComment',
    target: 'parentView.controller',

    didInsertElement: function() {
      this._super();
      this.$().focus().autosize().css('resize','none');
    },

    click: function(event) {
      event.stopPropagation();
    },

    keyPress: function(event) {
      if (event.keyCode === 13 && !event.ctrlKey) {
        event.preventDefault();
        if (this.get('value') !== '') {
          this.triggerAction();
        }
      }
    },
    
    cancel: function(event) {
      this.setPath('parentView.isVisible', false);
    }
  })
});