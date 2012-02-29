/**
  @param {Date|Ember.DateTime|String} 
    Can format either a native JS Date, Ember.DateTime instance or a ISO8601-
    formatted string.
  @param {Hash} opts
*/
Handlebars.registerHelper('formatTime', function(date, options) {
  var dateParams,
      dateTime,
      value = Ember.getPath(this, date),
      type = Ember.typeOf(value);
  console.log(value, type);
  if (type === 'date') {
    dateParams = value.getTime();
    dateTime = Ember.DateTime.create(dateParams);
  }

  if (type === 'instance') {
    dateTime = value;
  }

  if (type === 'string') {
    dateTime = Ember.DateTime.create(new Date(value).getTime());
  }

  if (value === undefined) {
    return undefined;
  } else {
    return dateTime.toFormattedString('%i:%M %p');
  }
});