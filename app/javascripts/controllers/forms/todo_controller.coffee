Radium.FormsTodoController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  needs: ['users']
  users: Ember.computed.alias('controllers.users')
  canFinish: (->
    @get('isDisabled') || @get('isNew')
  ).property('isDisabled', 'isNew')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    unless @get('isNew')
      @get('content.transaction').commit()
      return

    todo = Radium.Todo.createRecord @get('data')

    todo.get('transaction').commit()

    @set 'isExpanded', false

  justAdded: (->
    @get('content.justAdded') == true
  ).property('content.justAdded')

  showOptions: Ember.computed.alias('isNew')

  showComments: (->
    return false if @get('justAdded')
    @get 'hasComments'
  ).property('justAdded', 'comments.length')

  showSuccess: Ember.computed.alias('justAdded')

  isEditable: (->
    return false if @get('justAdded')
    @get('content.isEditable') == true
  ).property('content.isEditable')

  isExpandable: (->
    return false if @get('justAdded')
    !@get('isNew') && !@get('isFinished')
  ).property('isNew', 'isFinished')

  isExpandableDidChange: (->
    if !@get('isExpandable') then @set('isExpanded', false)
  ).observes('isExpandable')

  isDisabled: Ember.computed.not('isEditable')

  isPrimaryInputDisabled: (->
    return false if @get('isNew')
    return true unless @get('isExpanded')
    @get 'isDisabled'
  ).property('isDisabled', 'isExpanded', 'isNew')
