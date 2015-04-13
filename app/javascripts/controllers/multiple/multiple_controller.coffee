Radium.MultipleController = Radium.ArrayController.extend
  actions:
    addNew: ->
      currentIndex = @get('length')
      label = @get('labels')[currentIndex % @get('labels.length')]
      item = Ember.Object.create isPrimary: false, name: label, value: ''
      @get('content').pushObject  item

      false

  labels: ['Work', 'Personal']

  currentLabel: Ember.computed 'item.name', ->
    @get('item.name')?.toLowerCase().capitalize()

  arrangedContent: Ember.computed 'content.[]', ->
    @get('content').sort (a, b) ->
      if a.get('isPrimary') then -1 else 1
