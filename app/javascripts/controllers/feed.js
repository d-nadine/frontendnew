Radium.feedController = Ember.ArrayProxy.create({
  content: Radium.store.filter(Radium.Todo, function(data) {
    if (data.get('id') < 100) return true;
  })
});