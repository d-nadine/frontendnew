define('mixins/data', function(require) {
  require('ember');
  require('data');
  
  DS.radiumFixtureAdapter = DS.Adapter.create({
    find: function(store, type, id) {
      console.log(type);
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
});