window.Radium = Ember.Application.create({
  store: DS.Store.create({
    adapter: RadiumAdapter.create({bulkCommit: false})
  })
});