Radium.AddDealComponent = Ember.Component.extend
  actions:
    addDeal: ->
      @set('isSubmitted', true)
      return unless @get('parent.deal')

      debugger

      unless @get('isNew')
        @get('store').commit()

      @send 'closeForm'
      false

    closeForm: ->
      @get('targetObject').send 'toggleAddDealForm'
      false

  store: Ember.computed ->
    @get('container').lookup('store:main')

  isSubmitted: false

  dealsExist: Ember.computed ->
    Radium.Deal.all().get('length')

  classNameBindings: [':email-item-actions', ':new-message-row', ':block-blue']

  dealPicker: Radium.Combobox.extend
    actions:
      selectObject: (item) ->
        @_super.apply this, arguments
        @get("controller").send 'addDeal'

    valueBinding: 'controller.targetObject.deal'
    sourceBinding: 'controller.targetObject.controllers.deals'
    leader: 'Add Deal'
    isSubmittedBinding:'controller.isSubmitted'

    didInsertElement: ->
      @_super.apply this, arguments
      @$('input[type=text]').focus()

    lookupQuery: (query) ->
      @get('source').find (item) -> item.get('name') == query

    keyDown: (e) ->
      return unless e.keyCode == 13

      @get("controller").send 'addDeal'
