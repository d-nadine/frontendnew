Radium.GlobalSearchTextView = Ember.View.extend({
  classNames: 'span9'.w(),
  template: Ember.Handlebars.compile('<input type="text" class="prependedInput span9" placeholder="Find me..." id="search-box">')
});