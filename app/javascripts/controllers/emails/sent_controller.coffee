Radium.EmailsSentController = Radium.ObjectController.extend Radium.EmailDealMixin,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      # disable for now
      # callForm: @get('callForm')
  ).property('todoForm', 'callForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  showTasksButton: ( ->
    return if @get('isSaving') || @get('isPersonal')

    true
  ).property('isSaving', 'isPersonal')
