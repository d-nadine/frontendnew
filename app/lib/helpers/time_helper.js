/**
  Formats a variety of date formats into the standard 12-hour clock 
  time format.

  @param {Date|Ember.DateTime|String} property
    Can format either a native JS Date, Ember.DateTime instance or a ISO8601-
    formatted string.
  @param {Hash} options
  @return {String} A time string eg: '8:31 AM'
*/
Handlebars.registerHelper('formatTime', function(property, options) {
  var dateParams,
      view = options.data.view,
      context = (options.context && options.context[0]) || this,
      value = Ember.getPath(this, property);

  var parseDate = function(value) {
    var date,
        type = Ember.typeOf(value);

    if (type === 'date') {
      dateParams = value.getTime();
      date = Ember.DateTime.create(dateParams);
    }
    
    if (type === 'instance') {
      date = value;
    }

    if (type === 'string') {
      date = Ember.DateTime.create(new Date(value).getTime());
    }

    return date.toFormattedString('%i:%M %p');
  };

  // Observer function, rerenders the view with the updated date.
  var observer = function() {
    var newValue = Ember.getPath(context, property),
        // type = Ember.typeOf(newValue),
        updatedDate = parseDate(newValue);
    view.$().text(updatedDate);
    view.rerender();
  };

  var invoker = function() {
    Ember.run.once(observer);
  };

  Ember.addObserver(context, property, invoker);

  if (value) {
    return parseDate(value);
  } else {
    return '';
  }
});