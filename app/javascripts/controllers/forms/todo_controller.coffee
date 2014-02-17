require 'controllers/forms/form_controller'
require 'lib/radium/buffered_proxy'

Radium.FormsTodoController = Radium.FormController.extend BufferedProxy,
  needs: ['users']

  actions:
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

        @applyBufferedChanges()

        if @get('isNew')
          @get('model').commit().then(( (confirmation) =>
            if @get('controllers.application.currentPath') != 'user.index'
              @get('user')?.reload()

            @send('flashSuccess', confirmation) if confirmation
          ),
          ((error) =>
            @send 'flashError', error
            error.deleteRecord()
          ))
        else
          @get('store').commit()

        Ember.run.next =>
          if parentController = @get('parentController')
            if parentController instanceof Radium.CalendarTaskController
              parentController.get('controllers.calendarSidebar').notifyPropertyChange('items')

        if @get('parentController') instanceof Radium.CalendarTaskController
          @set('isExpanded', true)

        @discardBufferedChanges()

        return unless @get('isNew')

        @get('model').reset()
        @trigger('formReset')
      ), 1200)

  init: ->
    @_super.apply this, arguments

  canFinish: (->
    @get('isDisabled') || @get('isNew')
  ).property('isDisabled', 'isNew')

  isFinished: ((key, value) ->
    model = @get('content')

    if arguments.length == 2
      model.set('isFinished', value)

      unless model.get('isNew')
        model.one 'didUpdate', (result) =>
          if @get('controllers.application.currentPath') != 'user.index'
            @get('user')?.reload()

        @get('store').commit()
    else
      model.get('isFinished')
  ).property('content.isFinished')

  isValid: ( ->
    return if Ember.isEmpty(@get('description').trim())
    return if @get('finishBy').isBeforeToday()
    return unless @get('user')

    true
  ).property('description.length', 'finishBy', 'user', 'model.submitForm')

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

  hasReference: ( ->
    reference = @get('reference')
    !@get('isNew') && reference
  ).property('reference', 'isNew')

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
