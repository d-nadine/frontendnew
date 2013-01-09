/**
  Formats a native JS Date object for now into the format of your choice.
  See `ember-datetime.js` at line 325 for more options.

  @param {Date} property
  @param {Hash} options.hash.format An Ember.DateTime string format
  @return {String} A formatted date string eg: "January 1, 2012"
*/
return Handlebars.registerHelper('formatDate', function(property, options) {
  var context = (options.context && options.context[0]) || this,
      view = options.data.view,
      value = Ember.get(this, property),
      type = Ember.typeOf(value),
      optionFormat = options.hash.format,
      format = (optionFormat) ? optionFormat : "%B %D, %Y";


  var parseDate = function(date) {
    var tomorrow = Ember.DateTime.create().advance({day: 1});
    var today = Ember.DateTime.create();
    var yesterday = Ember.DateTime.create().advance({day: -1});

    if (optionFormat) {
      return date.toFormattedString(format);
    }

    if (Ember.DateTime.compareDate(date, tomorrow) === 0) {
      return "Tomorrow";
    } else if (Ember.DateTime.compareDate(date, today) === 0) {
      return "Today";
    } else if (Ember.DateTime.compareDate(date, yesterday) === 0) {
      return "Yesterday";
    } else {
      return date.toFormattedString(format);
    }
  };

  // Observer function, rerenders the view with the updated date.
  var observer = function() {
    if(!elem) return;

    var elem = view.$();
    // Delete the observes if the view gets got.
    if (elem.length === 0) {
      Ember.removeObserver(context, property, invoker);
      return;
    }
    // Compute new date and update the view.
    var newValue = Ember.get(context, property),
        updatedDate = parseDate(newValue);
    view.$().text(updatedDate);
    view.rerender();
  };

  var invoker = function() {
    Ember.run.once(observer);
  };

  Ember.run(function() {
    Ember.addObserver(context, property, invoker);
  });

  return parseDate(value);
});
