Radium.ListEditorComponent = Ember.Component.extend Radium.ValidationMixin,
  actions:
    submit: ->
      @set 'isSubmitted', true

      Ember.run.next =>
        return unless @get('formValid')

        list = Radium.List.createRecord @get('list').getProperties('name', 'itemName', 'type')

        list.save().then =>
          @flashMessenger.success "List #{list.get('name')} created."

      false

    cancel: ->
      @reset()

      @get('modal').send 'closeModal'

      false

  listLabel: Ember.computed 'list', ->
    if @get('list.isNew')
      "New"
    else
      "Edit"

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set 'modal', @nearestOfType(Radium.XModalComponent)
    @$('input[type=text]:first').focus()

  nameValidations: ['required']
  itemNameValidations: ['required']

  errorMessages: Ember.A()

  formValid: Ember.computed.equal 'errorMessages.length', 0

  reset: ->
    @set 'isSubmitted', false
