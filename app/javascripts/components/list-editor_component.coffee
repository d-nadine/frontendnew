require "mixins/lists_persistence_mixin"

Radium.ListEditorComponent = Ember.Component.extend Radium.ValidationMixin,
  Radium.ListsPersistenceMixin,

  actions:
    submit: ->
      @set 'isSubmitted', true

      Ember.run.next =>
        return unless @get('formValid')

        return unless list = @get('list')

        props = list.getProperties('name', 'itemName', 'type')

        if list.get('isNew')
          record = Radium.List.createRecord props
        else
          record = Radium.List.all().find (l) -> l.get('id') == list.get('id')
          record.setProperties(props)

        record.save().then =>
          @flashMessenger.success "List #{list.get('name')} created."
          @sendAction 'closeModal'
          @sendAction 'updateTotals'

          if parentModel = @get('parentModel')
            @send 'addList', parentModel, record

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
