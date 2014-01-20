Radium.FormView = Radium.View.extend Radium.FlashNewViewMixin,
  didInsertElement: ->
    @_super.apply this, arguments

    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on

    return unless @get('controller.model.newTask')

    @set('controller.model.newTask', false)

    return unless @get('controller.parentController') instanceof Radium.TaskListItemController

    return if @get('controller.parentController.parentController.hiddenContent.length')

    Ember.run.scheduleOnce 'afterRender', this, 'scrollToTask'

  scrollToTask: ->
    return unless @$()

    top = @$().offset().top - 100

    Ember.$("body,html").animate
      scrollTop: top,
        duration: 500
        complete: =>
          @set('controller.isExpanded', true) if @get('controller')
