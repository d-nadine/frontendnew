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

      if model.get('isNew')
        return @get('items').removeObject item

      isPrimary = item.get('isPrimary')

      model.get(@get('relationship')).removeObject item

      if isPrimary
        model.get(@get('relationship')).get('firstObject').set 'isPrimary', true

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
