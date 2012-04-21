Radium.todosController = Ember.ArrayProxy.create({
  content: Radium.store.findAll(Radium.Todo)
})