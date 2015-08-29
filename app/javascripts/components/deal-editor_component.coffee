Radium.DealEditorComponent = Ember.Component.extend
  actions:
    cancel: ->
      @reset()

      @get('modal').send 'closeModal'

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set 'modal', @nearestOfType(Radium.XModalComponent)
    @$('input[type=text]:first').focus()

  reset: ->
    @set 'isSubmitted', false

  errorMessages: Ember.A()

  formValid: Ember.computed.equal 'errorMessages.length', 0