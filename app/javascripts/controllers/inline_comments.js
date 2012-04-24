Radium.inlineCommentsController = Ember.ArrayProxy.extend({
  content: [],
  newComment: "",
  addComment: function() {
    if (this.get('newComment') !== '') {
      this.set('newComment', '');
    } else {
      console.log('cannot add blank comments');
    }
  }
});