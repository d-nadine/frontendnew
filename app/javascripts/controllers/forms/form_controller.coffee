Radium.FormController = Ember.ObjectController.extend
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')

  showAddAction: ( ->
    not @get('isNew')
  ).property('isNew')

  toggleFormBox: ->
    @toggleProperty 'showFormBox'

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
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


