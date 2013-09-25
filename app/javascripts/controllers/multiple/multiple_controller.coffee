Radium.MultipleController = Radium.ArrayController.extend
  actions:
    addNew: ->
      currentIndex = @get('length')
      label = @get('labels')[currentIndex % @get('labels.length')]
      item = Ember.Object.create isPrimary: false, name: label, value: ''
      @get('content').pushObject  item

  labels: ['Work','Personal']
