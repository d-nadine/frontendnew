minispade.require('radium/views/ui/inline_select');

Ember.Handlebars.registerHelper('inlineSelect', function(path, options) {
  options.hash.valueBinding = path;
  return Ember.Handlebars.helpers.view.call(this, Radium.InlineSelect, options);
});