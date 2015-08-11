Radium.EmailsSentController = Radium.ObjectController.extend Radium.EmailDealMixin,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: null
    user: @get('currentUser')

  showTasksButton: Ember.computed 'isSaving', 'isPersonal', ->
    return if @get('isSaving') || @get('isPersonal')

    true

  to: Ember.computed 'toList.[]', 'toList.@each.isLoaded', ->
    return @get('toList')
