window.Radium = Ember.Application.create({
  _api: null,
  today: function() {
    return Ember.DateTime.create().toISO8601();
  }.property().cacheable(),
  store: DS.Store.create({
    revision: 3,
    adapter: DS.RadiumAdapter.create({bulkCommit: false})
  })
});

DS.Model.reopen({
  namingConvention: {
    keyToJSONKey: function(key) {
      return key;
    },

    foreignKey: function(key) {
      return key;
    }
  }
});