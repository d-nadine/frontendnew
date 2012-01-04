define('views/globalsearch', function(require) {
  
  Radium.GlobalSearchTextView = Ember.View.extend({
    template: Ember.Handlebars.compile('<fieldset><input type="text" class="prependedInput" placeholder="Find me..." id="search-box"></fieldset>')
  });
  
});