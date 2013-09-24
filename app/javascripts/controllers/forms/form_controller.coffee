Radium.FormController = Radium.ObjectController.extend Ember.Evented,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return

    toggleExpanded: ->
      @toggleProperty 'isExpanded'
      return

    expand: ->
      return unless @get('isExpandable')
      @toggleProperty 'isExpanded'
      return

  justAdded: (->
    @get('content.justAdded') == true
  ).property('content.justAdded')

  showOptions: Ember.computed.alias('isNew')

  submitFormDidChange: ( ->
    return unless @get('model.submitForm')
    @send 'submit'
    @set 'model.submitForm', false
  ).observes('model.submitForm')

  isPrimaryInputDisabled: (->
    return false if @get('isNew')
    return true unless @get('isExpanded')
    @get 'isDisabled'
  ).property('isDisabled', 'isExpanded', 'isNew')

  showComments: (->
    return false if @get('justAdded')
    return false if @get('isNew')
    true
  ).property('isNew', 'justAdded')

  showSuccess: Ember.computed.alias('justAdded')

  isEditable: (->
    return false if @get('isSubmitted')
    return false if @get('justAdded')
    return false if @get('isSaving')
    return true if @get('isNew')
    true
  ).property('content', 'content.isEditable', 'isSaving')

  isExpandable: (->
    return false if @get('justAdded')
    !@get('isNew') && !@get('isFinished')
  ).property('isNew', 'isFinished')

  modelIsExpandedDidChange: ( ->
    if model = @get('model')
      @set('isExpanded', model.get('isExpanded'))
  ).observes('model.isExpanded')

  isExpandableDidChange: (->
    if !@get('isExpandable') then @set('isExpanded', false)
  ).observes('isExpandable')

  isDisabled: (->
    return true if @get('justAdded')
    @get('content.isEditable') is false
  ).property('model', 'isEditable')

  hasComments: Ember.computed.present('comments')
  showAddAction: Ember.computed.not('isNew')

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


