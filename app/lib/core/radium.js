window.Radium = Ember.Application.create({
  store: DS.Store.create({
    adapter: 'DS.fixtureAdapter'
  })
});