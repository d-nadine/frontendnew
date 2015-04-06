require 'mixins/content_editable_behaviour'
##
# A component that can both display and edit conversations. Used like
# so:
#
#   {{rd-conversation-input value=theConversationBody editable=true}}
#
# conversation inputs can be both read-only or read-write depending on
# the value of the 'editable'
Radium.RdConversationInputComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  Radium.ContentEditableBehaviour,
  Ember.Evented,
  classNameBindings: [':rd-conversation-input', 'editable']
  attributeBindings: ['contenteditable']

  ##
  # Should this input be editable or not.
  editable: true

  ##
  # For HTML content to be editable, the value of the
  # "contenteditable" attribute must be the `String` "true".
  # The presence of the attribute alone won't cut it apparently, so we
  # compute off of the value of the `editable` property to set the HTML
  contenteditable: Ember.computed("editable", ->
    "true" if !!@get('editable')
  )

  ##
  # The content of the conversation. This is the primary public API
  # for using this component
  value: ""

  ##
  # Use this property to indicate that this input should receive focus
  focus: false

  ## Private API

  input: (e) ->
    text = @$().html()

    @set 'value', text

  focusOut: ->
    @set 'focus', false

  keyDown: (e) ->
    if e.keyCode == @ENTER
      docFragment = document.createDocumentFragment()
      newEle = document.createTextNode('\n')
      docFragment.appendChild newEle
      newEle = document.createElement('br')
      docFragment.appendChild newEle
      range = window.getSelection().getRangeAt(0)
      range.deleteContents()
      range.insertNode docFragment
      range = document.createRange()
      range.setStartAfter newEle
      range.collapse true
      sel = window.getSelection()
      sel.removeAllRanges()
      sel.addRange range
      false
      e.preventDefault()

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
