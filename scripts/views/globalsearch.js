define('views/globalsearch', function(require) {
  
  require('ember');
  var Radium = require('radium');
  
  Radium.GlobalSearchTextView = Ember.View.extend({
    template: Ember.Handlebars.compile('<fieldset><input type="text" class="prependedInput" placeholder="Find me..." id="search-box"></fieldset>')
  });
  
  return Radium;
  
});