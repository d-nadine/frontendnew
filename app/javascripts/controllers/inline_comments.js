Radium.inlineCommentsController = Ember.ArrayProxy.extend({
  content: [],
  newComment: "",
  isError: false,
  addComment: function() {
    var self = this;
    if (this.get('newComment') !== '') {
      var comment,
          id = this.getPath('activity.id');

      Radium.Comment.reopenClass({
        url: 'todos/%@/comments'.fmt(id),
        root: 'comment'
      });
      
      comment = Radium.store.createRecord(Radium.Comment, {
        text: this.get('newComment')
      });
      self.set('isError', false);

      Radium.store.commit();

      comment.addObserver('isValid', function() {
        if (this.get('isValid')) {
          Radium.Comment.reopenClass({
            url: null
          });

          self.set('newComment', '');
          self.get('content').pushObject(comment);
        } else {
          self.set('isError', true);
        }
      });
      
    } else {
      self.set('isError', true);
    }
  }
});