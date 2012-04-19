// TODO: Implement when upgraded to 0.9.6 so we can use `cacheFor`
Radium.CoffeeCupTotalView = Ember.View.extend({
  totalDidChange: function(sender, key, value, context, rev) {
    var content = this.get('content'),
        cachedContent = this.get('_cache');
console.log(arguments);
    if (content !== cachedContent) {
      console.log('change', content, cachedContent, value);
      this.set('_cache', content);
    }
  }.observes('content'),
  template: Ember.Handlebars.compile('{{content}} {{label}}')
});