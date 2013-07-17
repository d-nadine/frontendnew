require 'controllers/forms/form_controller' 
Radium.FormsTodoController = Radium.FormController.extend
  needs: ['users']

  canFinish: (->
    @get('isDisabled') || @get('isNew')
  ).property('isDisabled', 'isNew')

  isFinished: ((key, value) ->
    model = @get('content')

    if arguments.length == 2
      model.set('isFinished', value)

      unless model.get('isNew')
        @get('store').commit()
    else
      model.get('isFinished')
  ).property('content.isFinished')

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
    true
    # @get('content.isEditable') == true
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
