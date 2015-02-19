Radium.MultipleControlComponent = Ember.Component.extend Radium.ComponentContextHackMixin,
  actions:
    modelChanged: (object) ->
      @sendAction 'action', object

    addItem: ->
      currentIndex = @get('length')
      label = @labels[0]
      item = Ember.Object.create isPrimary: false, name: label, value: ''
      @get('items').pushObject  item

    removeItem: (item) ->
      model = @get('model')

      isPrimary = item.get('isPrimary')

      setFirstToPrimary = =>
        items = model.get(@get('relationship'))
        next = items.find (i) -> i != item
        next.set 'isPrimary', true

      if model.get('isNew')
        setFirstToPrimary() if isPrimary
        return @get('items').removeObject item

      model.get(@get('relationship')).removeObject item

      setFirstToPrimary() if isPrimary

      model.save(this)

    setPrimary: (item) ->
      Ember.run.next =>
        @get('items').setEach 'isPrimary', false
        item.set 'isPrimary', true

        model = @get('model')

        return if model.get('isNew')

        model.save(this)

  multiple: Ember.computed 'items.length', ->
    @get('items.length') > 1

  isLast: Ember.computed 'items.[]', 'item', ->
    @get('item') == @get('items.lastObject')

  labels: ['Work','Personal']
