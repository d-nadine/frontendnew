Radium.TokenView = Ember.View.extend({
  didInsertElement: function() {
    this.$().hide().fadeIn();
  },
  classNames: 'token'.w(),
  removeEmail: function(event) {
    event.preventDefault();
    this.$().fadeOut('fast', $.proxy(function() {
      this.getPath('collectionView.content').removeObject(this.get('content'));
    }, this));
    return false;
  },
  templateName: 'token'
});