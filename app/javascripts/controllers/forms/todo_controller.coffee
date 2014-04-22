require 'controllers/forms/form_controller'
require 'lib/radium/buffered_proxy'

Radium.FormsTodoController = Radium.FormController.extend BufferedProxy,
  needs: ['users']

  actions:
    finishTask: ->
      return if @get('cantFinish')

      @toggleProperty('isFinished')

      if @get('isFinished') && @get('hasBufferedChanges')
        timer = setInterval =>
          @set 'isFinishing', true
          @trigger('animateFinish')
          clearInterval timer
        , 4000

        @set 'timer', timer
      else
        clearInterval @get('timer') if @get('timer')

        @send('completeFinish') if @get("hasBufferedChanges")

      false

    completeFinish: ->
      @set("isFinishing", false)

      @applyBufferedChanges()

      @get('model').one 'didUpdate', ->
        if @get('controllers.application.currentPath') != 'user.index'
          @get('user')?.reload()

        unless reference = @get('reference')
          return

        reference.reload()

      @get('store').commit()

      @discardBufferedChanges()

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

        model = @get('model')

        if @get('isNew')
          model.commit().then(( (confirmation) =>
            if @get('controllers.application.currentPath') != 'user.index'
              @get('user')?.reload()

            @send('flashSuccess', confirmation) if confirmation
          ),
          ((error) =>
            @send 'flashError', error
            error.deleteRecord()
          ))
        else
          @send 'addErrorHandlersToModel', model
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

    trySubmit: ->
      return if @get('isNew')
      @send 'submit'

  init: ->
    @_super.apply this, arguments

  timer: null
  isFinishing: false

  cantFinish: Ember.computed 'isDisabled', 'isNew', 'isFinishing', ->
    @get('isDisabled') || @get('isNew') || @get('isFinishing')

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
