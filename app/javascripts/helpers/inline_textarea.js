minispade.require('radium/views/ui/inline_textarea');

Ember.Handlebars.registerHelper('inlineTextarea', function(path, options) {
  options.hash.valueBinding = path;
  return Ember.Handlebars.helpers.view.call(this, Radium.InlineTextArea, options);
});