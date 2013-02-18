Radium.CallForm = Ember.Object.extend
  isEditable: true
  chanChangeContact: true

  isFinished: false
  finishBy: Ember.DateTime.create().advance(day: 1)
