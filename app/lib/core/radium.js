window.Radium = Ember.Application.create({
  store: DS.Store.create({
    revision: 3,
    adapter: RadiumAdapter.create({bulkCommit: false})
  })
});