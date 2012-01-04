define('views/globalsearch', function(require) {
  var view;
  
  view = Ember.View.extend({
    template: Ember.Handlebars.compile('<fieldset><input type="text" class="prependedInput" placeholder="Find me..." id="search-box"></fieldset>')
  });
  
  return view;
});