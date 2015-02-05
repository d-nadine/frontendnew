Radium.FormController = Radium.ObjectController.extend Ember.Evented,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return

    toggleExpanded: ->
      @toggleProperty 'isExpanded'
      return

    expand: ->
      return if event.target.tagName == "A"
      return if !@get('isNew') && event.target.tagName == "TEXTAREA" && @get('isExpanded')
      return unless @get('isExpandable')
      @toggleProperty 'isExpanded'
      return

  justAdded: Ember.computed 'content.justAdded', ->
    @get('content.justAdded') == true

  isExpandable: Ember.computed 'isNew', 'isFinished', 'justAdded', ->
    return not !!@get('justAdded')

  showOptions: Ember.computed.alias('isNew')

  submitFormDidChange: Ember.observer('model.submitForm', ->
    return unless @get('model.submitForm')
    @send 'submit'
  ).on('init')

  isPrimaryInputDisabled: Ember.computed 'isDisabled', 'isExpanded', 'isNew', ->
    return false if @get('isNew')
    return true unless @get('isExpanded')
    @get 'isDisabled'

  showComments: Ember.computed 'isNew', 'justAdded', ->
    return false if @get('justAdded')
    return false if @get('isNew')
    true

  showSuccess: Ember.computed.alias('justAdded')

  isEditable: Ember.computed 'content', 'content.isEditable', 'isSaving', ->
    return true if @get('isNew')
    return false if @get('isSubmitted')
    return false if @get('justAdded')
    return false if @get('isSaving')
    true

  isDisabled: Ember.computed 'model', 'isEditable', ->
    return true if @get('justAdded')
    @get('content.isEditable') is false

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
