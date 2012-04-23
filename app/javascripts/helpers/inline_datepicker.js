Ember.Handlebars.registerHelper('inlineDatePicker', function(path, options) {
  options.hash.valueBinding = path;
  return Ember.Handlebars.helpers.view.call(this, Radium.InlineDatePicker, options);
});