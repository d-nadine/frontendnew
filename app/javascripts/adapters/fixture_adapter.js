var get = Ember.get;

Radium.FixtureAdapter = DS.FixtureAdapter.extend({
  simulateRemoteResponse: false,

  latency: 50,

  queryFixtures: function(records, query, type) {
    if(!records) return;

    fixtureType = type.toString().split(".")[1];
    queryMethod = "query" + fixtureType + "Fixtures";

    if(this[queryMethod]) {
      return this[queryMethod].call(this, records, query);
    } else {
      throw new Error("Implement " + queryMethod + " to query " + type + "!");
    }
  },

  willCreateRecord: function(type, record, transaction) {
    var recordType = type.toString().split(".")[1];
    createMethod = "willCreate" + recordType;

    if(this[createMethod]) {
      this[createMethod].call(this, record, transaction);
    }
  }
});

requireAll(/adapters\/fixture_adapter\/queries/);
requireAll(/adapters\/fixture_adapter\/create/);
