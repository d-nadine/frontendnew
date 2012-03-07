return Handlebars.registerHelper('formatDate', function(property, options) {
  var context = (options.context && options.context[0]) || this,
      view = options.data.view,
      value = Ember.getPath(this, property),
      type = Ember.typeOf(value),
      format = Ember.getPath('options.hash.format') || "%B %D, %Y";
      
  var parseDate = function(date) {
    var milli = date.getTime();
    var d = Ember.DateTime.create(milli);
    return d.toFormattedString(format);
  };

  // Observer function, rerenders the view with the updated date.
  var observer = function() {
    var newValue = Ember.getPath(context, property),
        updatedDate = parseDate(val);
    view.$().text(updatedDate);
    view.rerender();
  };

  var invoker = function() {
    Ember.run.once(observer);
  };

  Ember.addObserver(context, property, invoker);

  // var formats = {
  //   day: '%B %D, %Y',
  //   week: 'Week %W, %Y',
  //   month: '%B %Y',
  //   quarter: (function() {
  //     var month = value.get('month');
  //     if (month <= 3) { return '1st Quarter, %Y'}
  //     else if (month <= 6 && month > 3) { return '2nd Quarter, %Y'}
  //     else if (month <= 9 && month > 6) { return '3rd Quarter, %Y'}
  //     else if (month < 13 && month > 9) { return '4th Quarter, %Y'}
  //   })(),
  //   year: '%Y'
  // }
  // return value.toFormattedString(formats[type]);
  return parseDate(value);
});