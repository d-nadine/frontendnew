/**
  @param {Date|Ember.DateTime|String} 
    Can format either a native JS Date, Ember.DateTime instance or a ISO8601-
    formatted string.
  @param {Hash} opts
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


  var observer = function() {
    var val = Ember.getPath(context, property),
        type = Ember.typeOf(val),
        updatedDate = parseDate(val);
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