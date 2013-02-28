var get = Ember.get;

Radium.InMemoryAdapter = DS.FixtureAdapter.extend({
  simulateRemoteResponse: false,

  latency: 50,

  serializer: DS.FixtureSerializer.extend({
    addAttribute: function(hash, key, value) {
      hash[key] = value;
    },

    addId: function(hash, key, value) {
      hash[key] = value;
    },

    addBelongsTo: function(hash, record, key, relationship) {
      var id = get(record, relationship.key+'.id');
      if (!Ember.isNone(id)) { hash[key] = id; }
    },

    addHasMany: function(hash, record, key, relationship) {
      var ids = get(record, relationship.key).map(function(item) {
        return item.get('id');
      });

      hash[relationship.key] = ids;
    }
  }),

  /*
    Implement this method in order to provide data associated with a type
  */
  fixturesForType: function(type) {
    if (type.FIXTURES) {
      var fixtures = Ember.A(type.FIXTURES);
      return fixtures.map(function(fixture){
        if(!fixture.id){
          throw new Error('the id property must be defined for fixture %@'.fmt(fixture));
        }
        fixture.id = fixture.id + '';
        return fixture;
      });
    }
    return null;
  },

  storeFixture: function(type, fixture) {
    if(!type.FIXTURES) {
      type.FIXTURES = [];
    }

    var fixtures = type.FIXTURES;

    this.deleteLoadedFixture(type, fixture);

    fixtures.push(fixture);
  },

  /*
    Implement this method in order to provide provide json for CRUD methods
  */
  mockJSON: function(type, record) {
    return this.serialize(record, { includeId: true });
  },

  /*
    Adapter methods
  */
  generateIdForRecord: function(store, record) {
    return Ember.guidFor(record);
  },

  find: function(store, type, id) {
    var fixtures = this.fixturesForType(type),
        fixture;

    Ember.assert("Unable to find fixtures for model type "+type.toString(), !!fixtures);

    if (fixtures) {
      fixture = Ember.A(fixtures).findProperty('id', id);
    }

    if (fixture) {
      this.simulateRemoteCall(function() {
        this.didFindRecord(store, type, fixture, id);
      }, this);
    }
  },

  findMany: function(store, type, ids) {
    var fixtures = this.fixturesForType(type);

    Ember.assert("Unable to find fixtures for model type "+type.toString(), !!fixtures);

    if (fixtures) {
      fixtures = fixtures.filter(function(item) {
        return ids.indexOf(item.id) !== -1;
      });
    }

    if (fixtures) {
      this.simulateRemoteCall(function() {
        this.didFindMany(store, type, fixtures);
      }, this);
    }
  },

  findAll: function(store, type) {
    var fixtures = this.fixturesForType(type);

    Ember.assert("Unable to find fixtures for model type "+type.toString(), !!fixtures);

    this.simulateRemoteCall(function() {
      this.didFindAll(store, type, fixtures);
    }, this);
  },

  findQuery: function(store, type, query, array) {
    var fixtures = this.fixturesForType(type);

    fixtures = this.queryFixtures(fixtures, query, type);

    if (fixtures) {
      this.simulateRemoteCall(function() {
        this.didFindQuery(store, type, fixtures, array);
      }, this);
    }
  },

  createRecord: function(store, type, record) {
    var fixture = this.mockJSON(type, record);

    this.storeFixture(type, fixture);

    this.simulateRemoteCall(function() {
      this.didCreateRecord(store, type, record, fixture);
    }, this);
  },

  updateRecord: function(store, type, record) {
    var fixture = this.mockJSON(type, record);

    this.storeFixture(type, fixture);

    this.simulateRemoteCall(function() {
      this.didUpdateRecord(store, type, record, fixture);
    }, this);
  },

  deleteRecord: function(store, type, record) {
    var fixture = this.mockJSON(type, record);

    this.deleteLoadedFixture(type, fixture);

    this.simulateRemoteCall(function() {
      this.didDeleteRecord(store, type, record);
    }, this);
  },

  /*
    @private
  */
  deleteLoadedFixture: function(type, record) {
    var id = this.extractId(type, record);

    var existingFixture = this.findExistingFixture(type, record);

    if(existingFixture) {
      var index = type.FIXTURES.indexOf(existingFixture);
      type.FIXTURES.splice(index, 1);
      return true;
    }
  },

  findExistingFixture: function(type, record) {
    var fixtures = this.fixturesForType(type);
    var id = this.extractId(type, record);

    return this.findFixtureById(fixtures, id);
  },

  findFixtureById: function(fixtures, id) {
    var adapter = this;

    return Ember.A(fixtures).find(function(r) {
      if(''+get(r, 'id') === ''+id) {
        return true;
      } else {
        return false;
      }
    });
  },

  queryFixtures: function(records, query, type) {
    fixtureType = type.toString().split(".")[1];
    queryMethod = "query" + fixtureType + "Fixtures";

    if(this[queryMethod]) {
      return this[queryMethod].call(this, records, query);
    } else {
      throw new Error("Implement " + queryMethod + " to query " + type + "!");
    }
  }
});

requireAll(/adapters\/in_memory_adapter\/queries/);
