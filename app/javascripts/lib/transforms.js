/**
  Transforms
*/

Radium.transforms = {}

Radium.transforms.array = {
  fromData: function(serialized) {
    return (Ember.isArray(serialized) ? serialized : null);
  },
  toData: function(deserialized){
    return (Ember.isArray(deserialized) ? deserialized : null);
  }
};

// Object transform
Radium.transforms.object = {
  fromData: function(serialized) {
    return Ember.none(serialized) ? {} : serialized;
  },

  toData: function(deserialized) {
    return Ember.none(deserialized) ? {} : deserialized;
  }
};

// Transform for validating the string states of a Deal state property
Radium.transforms.dealState = {
  fromData: function(serialized) {
    if (serialized == null) {
      return 'pending';
    }
    return String(serialized);
  },
  toData: function(deserialized) {
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
Radium.transforms.todoKind = {
  fromData: function(serialized) {
    if (serialized == null) {
      return 'general';
    }
    return String(serialized);
  },
  toData: function(deserialized) {
    var kind = deserialized;

    if (deserialized == null ||
      ['call', 'general', 'support'].indexOf(deserialized) < 0) {
      kind = 'pending';
    }

    return String(kind);
  }
};

// Transform for validating the string states of an Invitation state property
Radium.transforms.inviteState = {
  fromData: function(serialized) {
    if (serialized == null) {
      return 'pending';
    }
    return String(serialized);
  },
  toData: function(deserialized) {
    var state = deserialized;
    if (['pending', 'confirmed', 'rejected'].indexOf(deserialized) < 0) {
      state = 'pending';
    }

    return String(state);
  }
};

Radium.transforms.datetime = {
  fromData: function(serialized) {
    var type = typeof serialized;

    if (type === "string" || type === "number") {
      var timezone = new Date().getTimezoneOffset(),
          serializedDate = Ember.DateTime.parse(serialized, Radium.transforms.datetime.format);
      return serializedDate.toTimezone(timezone);
    } else if (Em.none(serialized)) {
      return serialized;
    } else {
      return null;
    }
  },

  toData: function(deserialized) {
    if (deserialized instanceof Ember.DateTime) {
      var normalized = deserialized.advance({timezone: 0});
      return normalized.toFormattedString(Radium.transforms.datetime.format);
    } else if (deserialized === undefined) {
      return undefined;
    } else {
      return null;
    }
  },

  format: Ember.DATETIME_ISO8601
};

Radium.transforms.date = {
  fromData: function(serialized) {
    var type = typeof serialized;

    if (type === "string" || type === "number") {
      return new Date(serialized);
    } else if (serialized === null || serialized === undefined) {
      // if the value is not present in the data,
      // return undefined, not null.
      return serialized;
    } else {
      return null;
    }
  },

  toData: function(date) {
    var type = typeof date;
    if (type === "string") {
      return date;
    } else if (type === "date" || type === "object") {
      return Ember.DateTime.create(date.getTime()).toISO8601();
    }

    return Ember.DateTime.create().toISO8601();
  }
}
