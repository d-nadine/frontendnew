require 'mixins/content_editable_behaviour'

Radium.RdConversationInputComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  Radium.ContentEditableBehaviour,
  Ember.Evented,
  classNameBindings: [':rd-conversation-input', 'editable']
  attributeBindings: ['contenteditable']

  editable: true

  contenteditable: Ember.computed("editable", ->
    "true" if !!@get('editable')
  )

  value: ""

  focus: false

  input: (e) ->
    text = @$().html()

    @set 'value', text

  focusOut: ->
    @set 'focus', false

  _setup: Ember.on 'didInsertElement', ->
    @get('targetObject').on('formReset', this, 'onFormReset')
    value = @get('value') || ''

    return unless value.length

    @$().html(value)

  requestFocus: Ember.observer('focus', ->
    Ember.run.next =>
      return unless @$()?
      if @get 'focus'
        @$().focus()
      else
        @$().blur()
  ).on 'didInsertElement'

  onFormReset: ->
    @set 'value', ''
    @$().html('')
