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
    return Ember.none(serialized) ? {} : serialized;
  },

  to: function(deserialized) {
    return Ember.none(deserialized) ? {} : deserialized;
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

DS.attr.transforms.datetime = {
  from: function(serialized) {
    var type = typeof serialized;

    if (type === "string" || type === "number") {
      var timezone = new Date().getTimezoneOffset(),
          serializedDate = Ember.DateTime.parse(serialized, DS.attr.transforms.datetime.format);
      return serializedDate.toTimezone(timezone);
    } else if (Em.none(serialized)) {
      return serialized;
    } else {
      return null;
    }
  },

  to: function(deserialized) {
    if (deserialized instanceof Ember.DateTime) {
      var normalized = deserialized.advance({timezone: 0});
      return normalized.toFormattedString(DS.attr.transforms.datetime.format);
    } else if (deserialized === undefined) {
      return undefined;
    } else {
      return null;
    }
  },

  format: Ember.DATETIME_ISO8601
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