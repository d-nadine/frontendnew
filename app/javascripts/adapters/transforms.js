DS.attr.transforms.array = {
  from: function(serialized) {
    return serialized;
  },
  to: function(array) {
    return array;
  }
};

// Shim for validating the string states of a Deal model only.
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

DS.attr.transforms.object = {
  from: function(serialized) {
    return Em.none(serialized) ? {} : serialized;
  },

  to: function(deserialized) {
    return Em.none(serialized) ? {} : serialized;
  }
};

DS.attr.transforms.date.to = function(date) {
  var type = typeof date;
  if (type === "string") {
    return date;
  } else if (type === "date") {
    return Ember.DateTime.create(date.getTime()).toISO8601();
  }

  return Ember.DateTime.create().toISO8601();
};

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
}