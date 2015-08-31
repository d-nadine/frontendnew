Radium.DealEditorComponent = Ember.Component.extend
  actions:
    cancel: ->
      @reset()

      @get('modal').send 'closeModal'

      false

    submit: ->
      p @get('newDeal')

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set 'modal', @nearestOfType(Radium.XModalComponent)
    @$('input[type=text]:first').focus()

    dealForm =
      company: null
      contact: null
      name: null

    @set 'newDeal', dealForm

  reset: ->
    @set 'isSubmitted', false
    @set 'newDeal', null

  errorMessages: Ember.A()

  formValid: Ember.computed.equal 'errorMessages.length', 0
