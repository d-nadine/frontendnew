Radium.FormController = Radium.ObjectController.extend Ember.Evented,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return

    toggleExpanded: ->
      @toggleProperty 'isExpanded'
      return

  justAdded: Ember.computed 'content.justAdded', ->
    @get('content.justAdded') == true

  isExpandable: Ember.computed 'isNew', 'isFinished', 'justAdded', ->
    return not !!@get('justAdded')

  isPrimaryInputDisabled: Ember.computed 'isDisabled', 'isExpanded', 'isNew', ->
    return false if @get('isNew')
    return true unless @get('isExpanded')
    @get 'isDisabled'

  showComments: Ember.computed 'isNew', 'justAdded', ->
    return false if @get('justAdded')
    return false if @get('isNew')
    true

  showSuccess: Ember.computed.alias('justAdded')

  isDisabled: Ember.computed 'model', ->
    return true if @get('justAdded')
    false

  hasComments: Ember.computed.present('comments')
  showAddAction: Ember.computed.not('isNew')

  formBox: Ember.computed 'todoForm', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: Ember.computed 'model', 'tomorrow', ->
    reference: @get('model')
    finishBy: null
    user: @get('currentUser')
