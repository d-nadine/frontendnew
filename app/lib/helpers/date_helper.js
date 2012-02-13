return Handlebars.registerHelper('formatDate', function(date, options) {
  var value = Ember.getPath(this, date);
  var type = Ember.getPath(this, 'type');
  var formats = {
    day: '%B %D, %Y',
    week: 'Week %W, %Y',
    month: '%B %Y',
    quarter: (function() {
      var month = value.get('month');
      if (month <= 3) { return '1st Quarter, %Y'}
      else if (month <= 6 && month > 3) { return '2nd Quarter, %Y'}
      else if (month <= 9 && month > 6) { return '3rd Quarter, %Y'}
      else if (month < 13 && month > 9) { return '4th Quarter, %Y'}
    })(),
    year: '%Y'
  }
  return value.toFormattedString(formats[type]);
});