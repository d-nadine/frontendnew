require 'controllers/form_array_behaviour'

Radium.MultipleControlComponent = Ember.Component.extend Radium.ComponentContextHackMixin,
  Radium.FormArrayBehaviour,
  actions:
    saveModel: ->
      @sendAction('saveModel') if @get('saveModel')

    stopEditing: ->
      @sendAction 'saveModel' unless @get('model.isNew')

    removeMultiple: (relationship, item) ->
      @get('model').get(@get('relationship')).removeObject item

    modelChanged: (object) ->
      @sendAction 'modelChanged', object

    removeSelection: (object) ->
      @_super.apply this, arguments

      @send 'stopEditing'

    addItem: ->
      label = @labels[0]
      item = Ember.Object.create isPrimary: false, name: label, value: ''
      @get('items').pushObject  item

    queryProfile: (email) ->
      @sendAction 'queryProfile', email

  multiple: Ember.computed 'items.length', ->
    @get('items.length') > 1

  isLast: Ember.computed 'items.[]', 'item', ->
    @get('item') == @get('items.lastObject')

  labels: ['Work','Personal']

  parent: Ember.computed.oneWay 'items'

  currentLabel: Ember.computed 'item', 'item.name', ->
    @get('item.name')?.toLowerCase().capitalize()
