define('mixins/data', function(require) {
  require('ember');
  require('data');
  
  DS.radiumFixtureAdapter = DS.Adapter.create({
    find: function(store, type, id) {
      var fixtures = type.FIXTURES;

      ember_assert("Unable to find fixtures for model type "+type.toString(), !!fixtures);
      if (fixtures.hasLoaded) { return; }

      setTimeout(function() {
        store.loadMany(type, fixtures);
        fixtures.hasLoaded = true;
      }, 300);
    },

    findMany: function() {
      this.find.apply(this, arguments);
    },
    
    findAll: function(store, type) {
      var fixtures = type.FIXTURES;
      
      ember_assert("Unable to find fixtures for model type "+type.toString(), !!fixtures);
      if (fixtures.hasLoaded) { return; }

      setTimeout(function() {
        store.loadMany(type, fixtures);
        fixtures.hasLoaded = true;
      }, 300);
    }
  });

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
  }
});