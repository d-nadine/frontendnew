Radium.RdConversationInputComponent = Ember.Component.extend
  classNames: ['rd-conversation-input']
  attributeBindings: ['contenteditable']
  contenteditable: "true"
  value: ""
  focus: false

  input: ->
    @set 'value', @$().text()

  sync: Ember.observer 'value', ->
    unless @get('value') == @$().text()
      @$().text @get('value')

  requestFocus: Ember.observer('focus', ->
    if @get 'focus'
      @$().focus()
    else
      @$().blur()
  ).on 'didInsertElement'
