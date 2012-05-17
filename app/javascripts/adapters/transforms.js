/**
  Transforms
*/

// Array transforms
DS.attr.transforms.array = {
  from: function(serialized) {
    return (Ember.isArray(serialized) ? serialized : null);
  },
  to: function(deserialized){
    return (Ember.isArray(deserialized) ? deserialized : null);
  }
};

// Object transform
DS.attr.transforms.object = {
  from: function(serialized) {
    return Em.none(serialized) ? {} : serialized;
  },

  to: function(deserialized) {
    return Em.none(serialized) ? {} : serialized;
  }
};

// Transform for validating the string states of a Deal state property
DS.attr.transforms.dealState = {
  from: function(serialized) {
    if (serialized == null) {
      return 'pending';
    }
    return String(serialized);
  },
  to: function(deserialized) {
    var state;
    
    if (deserialized == null || 
      ['pending', 'closed', 'paid', 'rejected'].indexOf(deserialized) < 0) {
      state = 'pending';
    } else {
      state = deserialized;
    }

    return String(state);
  }
};

// Transform for validating the string states of a Todo kind property
DS.attr.transforms.todoKind = {
  from: function(serialized) {
    if (serialized == null) {
      return 'general';
    }
    return String(serialized);
  },
  to: function(deserialized) {
    var kind = deserialized;
    
    if (deserialized == null || 
      ['call', 'general', 'support'].indexOf(deserialized) < 0) {
      kind = 'pending';
    }

    return String(kind);
  }
};

// Transform for validating the string states of an Invitation state property
DS.attr.transforms.inviteState = {
  from: function(serialized) {
    if (serialized == null) {
      return 'pending';
    }
    return String(serialized);
  },
  to: function(deserialized) {
    var state = deserialized;
    if (['pending', 'confirmed', 'rejected'].indexOf(deserialized) < 0) {
      state = 'pending';
    }

    return String(state);
  }
};

DS.attr.transforms.dateTime = {
  from: function(serialized) {
    var type = typeof serialized;

    if (type === "string" || type === "number") {
      return Ember.DateTime.create(new Date(serialized));
    } else if (serialized === null || serialized === undefined) {
      // if the value is not present in the data,
      // return undefined, not null.
      return serialized;
    } else {
      return null;
    }
  },
  to: function(date) {
    return date.toISO8601();
  }
};

// Overwrite Ember Data's date to keep date's ISO8601 formatted.
DS.attr.transforms.date.to = function(date) {
  var type = typeof date;
  if (type === "string") {
    return date;
  } else if (type === "date" || type === "object") {
    return Ember.DateTime.create(date.getTime()).toISO8601();
  }

  return Ember.DateTime.create().toISO8601();
};