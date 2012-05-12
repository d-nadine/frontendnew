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
      var self = this;
      this._super();
      this.$().focus().autosize().css('resize','none');
      $('html').on('click.autoresize', function() {
        self.setPath('parentView.isAddingComment', false);
      });
    },

    willDestroyElement: function() {
      $('html').off('click.autoresize');
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
      this.setPath('parentView.isAddingComment', false);
    }
  }),

  isAddingComment: false,
  showCommentField: function(event) {
    this.set('isAddingComment', true);
    return false;
  }
});