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

});

Radium.FixtureAdapter.reopenClass({
  getCreateMethodForType: function(type){
    var typeName = type.toString().split('.').pop();

    return "createPreFilter" + typeName;
  },
});

requireAll(/adapters\/fixture_adapter\/queries/);
requireAll(/adapters\/fixture_adapter\/create/);
