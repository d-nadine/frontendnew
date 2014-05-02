##
# A component that can both display and edit conversations. Used like
# so:
#
#   {{rd-conversation-input value=theConversationBody editable=true}}
#
# conversation inputs can be both read-only or read-write depending on
# the value of the 'editable'
Radium.RdConversationInputComponent = Ember.Component.extend
  classNames: ['rd-conversation-input']
  classNameBindings: ['editable']
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

  input: ->
    @set 'value', @$().text()

  focusOut: ->
    @set 'focus', false

  sync: Ember.observer 'value', ->
    unless @get('value') == @$().text()
      @$().text @get('value')

  requestFocus: Ember.observer('focus', ->
    Ember.run.next =>
      return unless @$()?
      if @get 'focus'
        @$().focus()
      else
        @$().blur()
  ).on 'didInsertElement'
