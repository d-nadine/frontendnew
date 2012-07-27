Radium.InlineCommentsView = Ember.View.extend({
  templateName: 'inline_comments',
  // isVisibleBinding: 'parentView.isCommentsVisible',
  controllerBinding: 'parentView.controller',
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
    }
  })
});