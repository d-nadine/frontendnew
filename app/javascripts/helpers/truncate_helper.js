Ember.Handlebars.registerHelper('truncate', function(property, options) {
  var length = options.length || 25;

  var value = Ember.get(this, property);

  if(value.length >= length) {
    escaped = Handlebars.Utils.escapeExpression(value.slice(0, length-3) + '...')
  } else {
    escaped = Handlebars.Utils.escapeExpression(value.slice(0, length))
  }

  return new Handlebars.SafeString(escaped);
});
