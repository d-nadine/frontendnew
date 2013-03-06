Radium.FormsTodoController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  needs: ['users']
  users: Ember.computed.alias('controllers.users')

  canFinish: (->
    @get('isDisabled') || @get('isNew')
  ).property('isDisabled', 'isNew')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    isNew = @get('isNew')
    isBulk = @get('reference') && Ember.isArray @get('reference')

    @set 'isExpanded', false
    @set 'justAdded', true
    @set 'showOptions', false

    if isNew
      Radium.Todo.createRecord @get('data')

    if isBulk
      @get('reference').forEach (item) =>
        todo = Radium.Todo.createRecord @get('data')
        todo.set 'reference', item

    @get('store').commit()

    Ember.run.later( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false
      @set 'showOptions', true

      if isNew || isBulk
        @trigger('formReset')
    ), 1500)

  confirmationText: ( ->
    if @get('isNew')
      "Added"
    else
      "Updated"
  ).property('isNew')

  justAdded: (->
    @get('content.justAdded') == true
  ).property('content.justAdded')

  showOptions: Ember.computed.alias('isNew')

  showSuccess: Ember.computed.alias('justAdded')

  isEditable: (->
    return false if @get('isSubmitted')
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
