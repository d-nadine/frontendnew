window.Radium = Ember.Application.create({
  store: DS.Store.create({
    revision: 1,
    adapter: RadiumAdapter.create({bulkCommit: false})
  })
});