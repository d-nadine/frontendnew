Radium.XOptionComponent = Ember.Component.extend
  tagName: 'option'
  attributeBindings: ['selected', 'name', 'disabled', 'value']
  classNameBindings: [':x-option']

  value: null

  selected: Ember.computed 'value', 'select.value', ->
    @get('value') == @get('select.value')

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    select = @nearestOfType(Radium.XSelectComponent)

    Ember.assert "x-option component declared without enclosing x-select", !!select

    this.set('select', select)

    select.registerOption this

  teardown: ->
    @_super.apply this, arguments

    @get('select').unregisterOption
