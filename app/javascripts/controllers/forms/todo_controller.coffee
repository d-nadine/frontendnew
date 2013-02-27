Radium.FormsTodoController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users']
  users: Ember.computed.alias('controllers.users')

  submit: ->
    @set 'isSubmitted', true

    Radium.Todo.createRecord
      user: @get('user')
      finishBy: @get('finishBy')
      reference: @get('reference')
      description: @get('description')

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

  canFinish: (->
    @get('isDisabled') || @get('isNew')
  ).property('isDisabled', 'isNew')

  toggleExpanded: -> @toggleProperty 'isExpanded'

  expand: ->
    return unless @get('isExpandable')
    @toggleProperty 'isExpanded'

  hasComments: Radium.computed.isPresent('comments')
