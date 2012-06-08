Radium.Utils = {
  // Checks if the todo is being created after 5PM, and if so, push the finishBy date to tomorrow at 5PM.
  finishByDate: function(date) {
    var now = Ember.DateTime.create();

    if (now.get('hour') >= 17) {
      return now.advance({day: 1, hour: 17, minute: 0});
    } else {
      return now.adjust({hour: 17, minute: 0});
    }
  },
  // Borrowed from jQuery.Validation
  VALIDATION_REGEX: {
    email: /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i
  },
  DATES_REGEX: {
    monthDayYear: /(?:\d+\-\d+\-\d+)/
  },
  browserSupportsWeb: function(){
    return !!window.Worker;
  }
};
_.emberArrayGroupBy = function(emberArray, val) {
  var result = {}, key, value, i, l = emberArray.get('length'),
    iterator = _.isFunction(val) ? val : function(obj) { return obj.get(val); };

  for (i=0; i<l; i++) {
    value = emberArray.objectAt(i);
    key   = iterator(value, i);
    (result[key] || (result[key] = [])).push(value);
  }
  return result;
};
