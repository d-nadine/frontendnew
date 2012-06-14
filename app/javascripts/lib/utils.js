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
  browserSupportsWebWorkers: function(){
    return !!window.Worker;
  },

  pluckReferences: function(feed, silent) {
    return feed.map(function(item){
      var kind = item.kind,
          model = Radium[Radium.Utils.stringToModel(kind)],
          reference = item.reference[kind];

      Radium.store.load(model, reference);
      if (!silent) {
        return Radium.store.find(model, reference.id);
      }
    });
  },

  transformActivities: function(feed){
    var ids = feed.getEach('id');

    feed.forEach(function(item){
      var kind = item.kind,
          model = Radium[Radium.Utils.stringToModel(kind)],
          reference = item.reference[kind];

      item[kind] = reference;
    });
    
    if(!feed.length || feed.length === 0){
      return Ember.A();
    }else{
      Radium.store.loadMany(Radium.Activity, feed);
      this.pluckReferences(feed, true);
      return Radium.store.findMany(Radium.Activity, ids);
    }
  },

  stringToModel: function(string) {
    var camelize = Ember.String.camelize(string);
    return camelize.charAt(0).toUpperCase() + camelize.slice(1);
  }
};
Radium.DateDiff = {
  inDays: function(d1, d2) {
      var t2 = d2.getTime();
      var t1 = d1.getTime();

      return parseInt((t2-t1)/(24*3600*1000));
  },

  inWeeks: function(d1, d2) {
      var t2 = d2.getTime();
      var t1 = d1.getTime();

      return parseInt((t2-t1)/(24*3600*1000*7));
  },

  inMonths: function(d1, d2) {
      var d1Y = d1.getFullYear();
      var d2Y = d2.getFullYear();
      var d1M = d1.getMonth();
      var d2M = d2.getMonth();

      return (d2M+12*d2Y)-(d1M+12*d1Y);
  },

  inYears: function(d1, d2) {
      return d2.getFullYear()-d1.getFullYear();
  }
}

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
