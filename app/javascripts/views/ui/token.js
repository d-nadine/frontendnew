Radium.TokenView = Ember.View.extend({
  classNames: 'alert alert-info token'.w(),
  removeEmail: function(event) {
    this.getPath('parentView.content').removeObject(this.get('item'));
    event.preventDefault();
  },
  templateName: 'token'
});