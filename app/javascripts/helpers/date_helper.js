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
      value = Ember.getPath(this, property),
      type = Ember.typeOf(value),
      format = Ember.getPath('options.hash.format') || "%B %D, %Y";
      
  var parseDate = function(date) {
    if (date) {
      var milli;
      if (typeof date === 'string') {
        milli = new Date(date).getTime();
      } else {
        milli = date.getTime();  
      }
      
      var d = Ember.DateTime.create(milli);
      return d.toFormattedString(format);
    } else {
      return "";
    }
  };

  // Observer function, rerenders the view with the updated date.
  var observer = function() {
    var elem = view.$();
    // Delete the observes if the view gets got.
    if (elem.length === 0) {
      Ember.removeObserver(context, property, invoker);
      return;
    }
    // Compute new date and update the view.
    var newValue = Ember.getPath(context, property),
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