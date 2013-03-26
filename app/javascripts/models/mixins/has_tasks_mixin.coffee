Radium.HasTasksMixin = Ember.Mixin.create
  tasks: Radium.computed.required()

  hasTasks: (->
    @get('tasks.length')
  ).property('tasks.length')

  nextTask: (->
    @get 'tasks.firstObject'
  ).property('tasks.firstObject')
