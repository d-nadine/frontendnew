import Ember from 'ember';

var a_slice = Array.prototype.slice;

Radium.computed = {};

// TODO is it used somewhere? Let's remove this and other dead code.
Radium.computed.notEqual = function(dependentKey) {
  return Ember.computed(dependentKey, function(key, value) {
    return this.get(dependentKey) !== value;
  });
};

Radium.computed.isToday = function(dependentKey) {
  return Ember.computed(dependentKey, function() {
    return this.get(dependentKey).isToday();
  });
};

Radium.computed.isPast = function(dependentKey) {
  return Ember.computed(dependentKey, function() {
    if (!this.get(dependentKey)) {
      return;
    }
    return this.get(dependentKey).isPast();
  });
};

Radium.computed.isFuture = function(dependentKey) {
  return Ember.computed(dependentKey, function() {
    return this.get(dependentKey).isFuture();
  });
};

Radium.computed.daysOld = function(dependentKey, days) {
  return Ember.computed(dependentKey, function() {
    var now;
    now = Ember.DateTime.create();
    return this.get(dependentKey).daysApart(now) >= days;
  });
};

Radium.computed.newForm = function(form, properties) {
  var defaultsName, type;
  if (properties == null) {
    properties = {};
  }
  defaultsName = "" + form + "FormDefaults";
  type = Radium["" + (form.capitalize()) + "Form"];
  return Ember.computed(defaultsName, function() {

    form = type.create(properties, {
      content: Ember.Object.create(),
      isNew: true,
      defaults: this.get(defaultsName)
    });
    return form;
  });
};

Radium.computed.aggregate = function() {
  var args, options, properties;
  properties = a_slice.call(arguments);
  args = properties.map(function(prop) {
    return "" + prop;
  });
  options = {
    initialValue: [],
    addedItem: function(array, item) {
      var observer;
      if (array.contains(item)) {
        return array;
      }
      observer = function() {
        if (!item.get('isLoaded')) {
          return;
        }
        item.removeObserver('isLoaded', observer);
        return array.addObject(item);
      };
      if (item.get('isLoaded')) {
        observer();
      } else {
        item.addObserver('isLoaded', observer);
      }
      return array;
    },
    removedItem: function(array, item) {
      if (!array.length) {
        return array;
      }
      if (!array.contains(item)) {
        return array;
      }
      array.removeObject(item);
      return array;
    }
  };
  args.push(options);
  return Ember.arrayComputed.apply(this, args);
};

Radium.computed.tasks = function() {
  var args, options, properties;
  properties = a_slice.call(arguments);
  args = properties.map(function(prop) {
    return "" + prop;
  });
  args.forEach(function(arg) {
    return args.push("" + arg + ".@each.{isFinished,isDeleted}");
  });
  options = {
    initialValue: [],
    sortFunc: function(left, right) {
      var compare;
      if (!left.get('time') && !right.get('time')) {
        return Ember.compare(left.get("displayName"), right.get("displayName"));
      }
      if (left.get('time') && !right.get('time')) {
        return 1;
      } else if (!left.get('time') && right.get('time')) {
        return -1;
      }
      compare = Ember.DateTime.compare(left.get("time"), right.get("time"));
      if (compare === 0) {
        return Ember.compare(left.get("displayName"), right.get("displayName"));
      } else {
        return compare;
      }
    },
    addedItem: function(array, item) {
      var observer;
      if (array.contains(item)) {
        return array;
      }
      if (item.get('isFinished')) {
        return array;
      }
      observer = function() {
        if (!item.get('isLoaded')) {
          return;
        }
        item.removeObserver('isLoaded', observer);
        if (array.contains(item)) {
          return;
        }
        if (item.get('isFinished')) {
          return;
        }
        if (item.get('isDeleted')) {
          return;
        }
        array.pushObject(item);
        return array.sort(options.sortFunc);
      };
      if (item.get('isLoaded')) {
        observer();
      } else {
        item.addObserver('isLoaded', observer);
      }
      return array;
    },
    removedItem: function(array, item) {
      if (!array.length) {
        return array;
      }
      if (!array.contains(item)) {
        return array;
      }
      array.removeObject(item);
      return array;
    }
  };
  args.push(options);
  return Ember.arrayComputed.apply(this, args);
};

Radium.computed.required = function() {
  return Ember.computed(function() {
    throw new Error("" + this.constructor + " does not implement the tasks interface");
  });
};

Radium.computed.kindOf = function(property, type) {
  return Ember.computed(property, function() {
    return this.get(property) instanceof type;
  });
};

Radium.computed.primary = function(collection) {
  var isPrimaryKey, itemsKey;
  itemsKey = "" + collection + ".length";
  isPrimaryKey = "" + collection + ".@each.isPrimary";
  return Ember.computed(isPrimaryKey, itemsKey, function() {
    if (!this.get(collection).get('length')) {
      return;
    }
    return this.get(collection).find(function(item) {
      return item.get('isPrimary');
    });
  });
};

Radium.computed.primaryAccessor = function(collection, prop, dependentKey) {
  var accessKey;
  accessKey = "" + dependentKey + "." + prop;
  return Ember.computed(accessKey, function(key, value) {
    var hash;
    if (arguments.length === 1) {
      return this.get(accessKey);
    }
    if (!this.get(dependentKey)) {
      hash = {
        name: 'work',
        isPrimary: true
      };
      hash[prop] = value;
      this.get(collection).createRecord(hash);
    } else {
      this.set(accessKey, value);
    }
    this.notifyPropertyChange(dependentKey);
    return value;
  });
};

Radium.computed.total = function(collection, key) {
  var dependentKey;
  if (key == null) {
    key = 'value';
  }
  dependentKey = "" + collection + ".[]";
  return Ember.computed(dependentKey, function() {
    if (!this.get(collection).get('length')) {
      return 0;
    }
    return this.get(collection).reduce(function(preVal, item) {
      return preVal + item.get(key) || 0;
    }, 0, key);
  });
};

Radium.computed.addAllKeysProperty = function(context, propertyName, objectPath, func) {
  var args, subject;
  subject = context.get(objectPath);
  args = Ember.keys(subject).map(function(key) {
    return "" + objectPath + "." + key;
  });
  if (typeof func !== 'function') {
    args.push.apply(args, a_slice.call(arguments, 3, -1));
  }
  args.push(a_slice.call(arguments, -1)[0]);
  return Ember.defineProperty(context, propertyName, Ember.computed.apply(this, args));
};

Radium.isPrimaryComparer = function(left, right) {
  if (left.get('isPrimary')) {
    return -1;
  }
  if (right.get('isPrimary')) {
    return 1;
  }
  return 0;
};

Radium.computed.sortByPrimary = function(key, relationship) {
  var arrayProp, func, isPrimaryProp, path;
  path = "" + key + "." + relationship;
  arrayProp = "" + path + ".[]";
  isPrimaryProp = "" + path + ".@each.isPrimary";
  func = function() {
    var coll;
    if (!(coll = this.get(path))) {
      return;
    }
    return coll.toArray().sort(Radium.isPrimaryComparer);
  };
  return Ember.computed(arrayProp, isPrimaryProp, func);
};

export default Radium.computed;
