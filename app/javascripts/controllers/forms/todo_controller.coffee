require 'controllers/forms/form_controller'
require 'lib/radium/buffered_proxy'
require 'mixins/user_combobox_props'

Radium.FormsTodoController = Radium.FormController.extend BufferedProxy,
  Radium.UserComboboxProps,

  actions:
    finishTask: ->
      return if @get('cantFinish')

      @toggleProperty('isFinished')

      if @get('isCalendar')
        @send('completeFinish') if @get("hasBufferedChanges")
        return

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
        isFinished = !!!model.get('isFinished')
        model.set('isFinished', isFinished)

        model.save().then ->
          if currentPath != 'user.index'
            user?.reload()

          unless reference
            return

          reference.reload()

      unless @get('animate')
        return finish()

      ele.fadeOut ->
        finish()

    submit: ->
      @set 'isSubmitted', true

      unless @get('isValid')
        @set 'isExpanded', true
        return

      @set 'isExpanded', false
      @set 'justAdded', true

      Ember.run.later(( =>
        @set 'justAdded', false
        @set 'isSubmitted', false

        @applyBufferedChanges()

        model = @get('model')

        if @get('isNew')
          model.commit().then(( (result) =>
            if @get('controllers.application.currentPath') != 'user.index'
              @get('user')?.reload()

            @send('flashSuccess', result.confirmation) if result?.confirmation

            # A bit hacky, we could use sendAction if this was a component
            if @get('target') instanceof Radium.NextTaskComponent
              @get('target').send 'todoAdded', result.todo
          ),
          ((error) =>
            @send 'flashError', error
          ))
        else
          # HACK: no other way to set finishBy to nil
          unless @get('model.finishBy')
            data = this.get('data')
            data.finishBy = null
            model.set('_data', data)
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

  needs: ['users']

  timer: null

  isCalendar: Ember.computed.equal 'controllers.application.currentPath', 'calendar.task'
  animate: Ember.computed.not 'isCalendar'

  cantFinish: Ember.computed 'isDisabled', 'isNew', ->
    @get('isDisabled') || @get('isNew')

  isValid: Ember.computed 'description.length', 'finishBy', 'user', 'model.submitForm', ->
    return if Ember.isEmpty(@get('description').trim())
    finishBy = @get('finishBy')

    return if finishBy && finishBy.isBeforeToday()

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

  showSuccess: Ember.computed.alias('justAdded')

  hasReference: Ember.computed 'reference', 'isNew', ->
    reference = @get('reference')
    !@get('isNew') && reference

  isDisabled: Ember.computed.not('isEditable')

  isPrimaryInputDisabled: Ember.computed 'isDisabled', 'isExpanded', 'isNew', ->
    return false if @get('isNew')
    return true unless @get('isExpanded')
    @get 'isDisabled'
