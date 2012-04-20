Radium.campaignsController = Ember.ArrayProxy.create({
  content: Radium.store.findAll(Radium.Campaign)
});