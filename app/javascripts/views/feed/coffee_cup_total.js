Radium.CoffeeCupTotalView = Ember.View.extend({
  totalDidChange: function() {
    console.log('FLASH!');
  }.observes('content'),
  template: Ember.Handlebars.compile('{{content}} {{label}}')
});