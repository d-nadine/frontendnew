Radium.InlineCommentsController = Ember.ArrayProxy.extend({
  newComment: "",
  isError: false,
  isSubmitting: false,
  addComment: function() {
    var self = this;
    if (this.get('newComment') !== '') {
      var comment,
          commentText = this.get('newComment'),
          id = this.getPath('reference.id'),
          // Activities don't have a reference type, only distinguishing key ATM
          type = this.getPath('reference.type') || this.getPath('reference.kind'),
          url;
      if (this.getPath('reference.type')) {
        var plural = Radium.store.adapter.pluralize(type);
        url = '%@/%@/comments'.fmt(plural, id);
      } else {
        url = 'activities/%@/comments'.fmt(id);
      }

      Radium.Comment.reopenClass({
        url: url,
        root: 'comment'
      });

      comment = Radium.store.createRecord(Radium.Comment, {
        text: commentText,
        createdAt: Ember.DateTime.create(),
        user: Radium.usersController.get('loggedInUser')
      });

      this.set('isError', false);
      this.set('newComment', '');
      this.get('content').pushObject(comment);

      Radium.store.commit();

      comment.addObserver('isValid', function() {
        if (this.get('isValid')) {
          Radium.Comment.reopenClass({
            url: null,
            root: null
          });
        } else {
          self.set('isError', true);
          self.set('newComment', commentText);
        }
      });

    } else {
      self.set('isError', true);
    }
  }
});