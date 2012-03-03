window.Radium = Ember.Application.create({
  store: DS.Store.create({
    revision: 2,
    adapter: RadiumAdapter.create({bulkCommit: false})
  })
});