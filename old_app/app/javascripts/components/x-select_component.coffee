Radium.XSelectComponent = Ember.Component.extend
  tagName: 'select'
  classNameBindings: [':x-select']
  attributeBindings: [
    'disabled'
    'tabindex'
  ]

  disabled: false

  tabindex: 1

  options: Ember.computed ->
    Ember.A()

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @$().on('change', Ember.run.bind(this, ->
      @_updateValue()
    ))

  registerOption: (option) ->
    @get('options').addObject option

  unregisterOption: (option) ->
    @get('options').removeObject option

  teardown: Ember.on 'willDestroyElement', ->
    @$().off 'change'
    @get('options').clear()

  _updateValue: ->
    option = @get('options').find (o) -> o.$().is ':selected'

    value = option?.get('value')

    @set 'value', value

    @sendAction('action', value) if value
