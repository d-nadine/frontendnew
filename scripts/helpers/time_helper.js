define('helpers/time_helper', function(require) {

  return Handlebars.registerHelper('time', function(date, options) {
    var value = Ember.getPath(this, date);
    if (Ember.typeOf(value) === 'date') {
      var dateString = value.getTime();
      value = Ember.DateTime.create(dateString);
    }
    return value.toFormattedString('%i:%M %p');
  });

});