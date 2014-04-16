Radium.RdConversationInputComponent = Ember.Component.extend
  classNames: ['rr-conversation-input']
  attributeBindings: ['contenteditable']
  contenteditable: "true"
  value: ""
  focus: false

  input: ->
    @set 'value', @$().text()
  sync: (->
    unless @get('value') == @$().text()
      @$().text @get('text')
  ).observes 'text'
  requestFocus: (->
    if @get 'focus'
      @$().focus()
    else
      @$().blur()
  ).observes('focus').on 'didInsertElement'
