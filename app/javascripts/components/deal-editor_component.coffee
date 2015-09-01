Radium.DealEditorComponent = Ember.Component.extend
  actions:
    cancel: ->
      @reset()

      @get('modal').send 'closeModal'

      false

    submit: ->
      @set 'isSubmitted', true

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set 'modal', @nearestOfType(Radium.XModalComponent)

    dealForm =
      company: null
      contact: null
      name: null

    @set 'dealForm', dealForm

    Ember.run.scheduleOnce 'afterRender', this, '_afterRender'

  _afterRender: ->
    @_super.apply this, arguments
    @$('input[type=text]:first').focus()

  reset: ->
    @set 'isSubmitted', false
    @set 'dealForm', null

  errorMessages: Ember.A()

  formValid: Ember.computed.equal 'errorMessages.length', 0

  dealNamePlaceholder: Ember.computed 'dealForm.contact', 'dealForm.company', ->
    "New #{@get('list.itemName')}"

  orFields: ['dealForm.company', 'dealForm.contact']
  orValidations: ['or']
  nameValidations: ['required']
  isSubmitted: false
