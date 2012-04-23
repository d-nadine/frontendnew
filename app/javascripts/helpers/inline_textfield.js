minispade.require('radium/views/ui/inline_textfield');

Ember.Handlebars.registerHelper('inlineTextField', function(path, options) {
  options.hash.valueBinding = path;
  return Ember.Handlebars.helpers.view.call(this, Radium.InlineTextField, options);
});