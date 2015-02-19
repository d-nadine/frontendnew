Radium.MultipleControlComponent = Ember.Component.extend Radium.ComponentContextHackMixin,
  actions:
    modelChanged: (object) ->
      @sendAction 'action', object

    addItem: ->
      currentIndex = @get('length')
      label = @get('labels')[currentIndex % @get('labels.length')]
      item = Ember.Object.create isPrimary: false, name: label, value: ''
      @get('items').pushObject  item

    removeItem: (item) ->
      @get('items').removeObject item

  multiple: Ember.computed 'items.length', ->
    @get('items.length') > 1

  labels: ['Work','Personal']
