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
          @send 'completeFinish'
          clearInterval timer
        , 2000

        @set 'timer', timer
      else
        clearInterval @get('timer') if @get('timer')

        @send('completeFinish') if @get("hasBufferedChanges")

      false

    completeFinish: ->
      model = @get('model')
      user = model.get('user')
      reference = model.get('reference')
      currentPath = @get('controllers.application.currentPath')
      store = @get('store')
      ele = Ember.$("[data-model='#{model.constructor}'][data-id='#{model.get('id')}']")
      self = this

      finish = ->
        model.set('isFinished', true)

        model.one 'didUpdate', ->
          if currentPath != 'user.index'
            user?.reload()

          unless reference
            return

          reference.reload()

        store.commit()

      unless ele.length
        return self.send()

      ele.fadeOut ->
        finish()

    submit: ->
      @set 'isSubmitted', true

      unless @get('isValid')
        @set 'isExpanded', true
        return

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

  timer: null

  cantFinish: Ember.computed 'isDisabled', 'isNew', ->
    @get('isDisabled') || @get('isNew')

  isValid: Ember.computed 'description.length', 'finishBy', 'user', 'model.submitForm', ->
    return if Ember.isEmpty(@get('description').trim())
    return unless @get('finishBy')
    return if @get('finishBy').isBeforeToday()
    return unless @get('user')

    true

  isBulk: Ember.computed 'reference', ->
    Ember.isArray @get('reference')

  showComments: Ember.computed 'isNew', 'justAdded', 'isBulk', ->
    return false if @get('isBulk')
    return false if @get('justAdded')
    return false unless @get('id')

    true

  justAdded: Ember.computed 'content.justadded', ->
    @get('content.justAdded') == true

  showOptions: Ember.computed.alias('isNew')

  showSuccess: Ember.computed.alias('justAdded')

  hasReference: Ember.computed 'reference', 'isNew', ->
    reference = @get('reference')
    !@get('isNew') && reference

  isExpandable: Ember.computed 'isNew', 'isFinished', ->
    return false if @get('justAdded')
    !@get('isNew') && !@get('isFinished')

  isExpandableDidChange: Ember.observer 'isExpandable', ->
    if !@get('isExpandable') then @set('isExpanded', false)

  isDisabled: Ember.computed.not('isEditable')

  isPrimaryInputDisabled: Ember.computed 'isDisabled', 'isExpanded', 'isNew', ->
    return false if @get('isNew')
    return true unless @get('isExpanded')
    @get 'isDisabled'
