Radium.TokenView = Ember.View.extend({
  didInsertElement: function() {
    this.$().hide().fadeIn();
  },
  classNames: 'token'.w(),
  removeEmail: function(event) {
    var self = this;
    this.$().fadeOut('fast', function() {
      self.getPath('parentView.content').removeObject(self.get('item'));
    });
    return false;
    event.preventDefault();
  },
  templateName: 'token'
});