Radium.CustomfieldPickerComponent = Ember.Component.extend  Radium.KeyConstantsMixin,
  actions:
    modifyCustomFields: (item) ->
      if @get('isLastItem')
        @sendAction 'addNewCustomField'
      else
        @sendAction 'removeCustomField', @get('customField')

    changeCustomFieldType: (type) ->
      @set 'customField.type', type

      Ember.run.next =>
        @$('input:first').select().focus()

  customFieldTypes: Ember.A([
    "text",
    "date",
    "currency",
    "url",
    "dropdown"
  ])

  isSelect: Ember.computed.equal 'customField.type', 'dropdown'

  isLastItem: Ember.computed 'customField', 'lastItem', ->
    @get('customField') == @get('lastItem')

  isInvalid: Ember.computed 'customField.name', 'isSubmitted', ->
    return false unless @get('isSubmitted')

    text = $.trim(@get('customField.name') || '')

    !!!text.length

  keyDown: (e) ->
    return @_super.apply(this,arguments) unless [@ENTER, @TAB].contains(e.keyCode)

    @submit()

  input: (e) ->
    return unless e.target.tagName == 'INPUT'
    Ember.run.next =>
      @set 'customField.name', e.target.value

  submit: ->
    @set 'isSubmitted', true

    Ember.run.next =>
      return if @get('isInvalid')

      action = if @get('customField.isNew')
                 'createCustomField'
               else
                 'updateCustomField'

      @sendAction action, @get('customField')

  _setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, 'addEventHandlers'

  addEventHandlers: ->
    self = this

    input = @$('input[type=text]')

    Ember.run.next =>
      input.focus() if @get('customField.isNew')

    input.on 'blur', (e) ->
      Ember.run.next ->
        self.submit()

  _teardown: Ember.on 'willDestroyElement', ->
    @$('input[type=text]').off 'blur'
