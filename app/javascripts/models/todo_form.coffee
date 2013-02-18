Radium.TodoForm = Ember.Object.extend
  isEditable: true
  isFinished: false
  finishBy: Ember.DateTime.create().advance(day: 1)
