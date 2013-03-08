Radium.FormsTodoController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  needs: ['users']

  canFinish: (->
    @get('isDisabled') || @get('isNew')
  ).property('isDisabled', 'isNew')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @set 'isExpanded', false
    @set 'justAdded', true
    @set 'showOptions', false

    Ember.run.later(( =>
      @set 'justAdded', false
      @set 'isSubmitted', false
      @set 'showOptions', true

      @get('model').commit()

      @get('model').reset()

      if @get('isNew') || @get('isBulk')
        @trigger('formReset')
    ), 1200)

  isBulk: ( ->
    Ember.isArray @get('reference')
  ).property('reference')

  showComments: ( ->
    return false if @get('isBulk')
    return false if @get('justAdded')
    return false unless @get('id')

    true
  ).property('isNew', 'justAdded', 'isBulk')

  justAdded: (->
    @get('content.justAdded') == true
  ).property('content.justAdded')

  showOptions: Ember.computed.alias('isNew')

  showSuccess: Ember.computed.alias('justAdded')

  isEditable: (->
    return false if @get('isSubmitted')
    return false if @get('justAdded')
    return true if @get('isNew')
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
