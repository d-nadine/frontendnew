Radium.FlashNewViewMixin = Ember.Mixin.create
  didInsertElement: ->
    @_super.apply this, arguments
    controller = @get('controller')

    return unless controller.get('newTask')

    @$().addClass('is-new-item')

    Ember.run.later(this, =>
      @$()?.removeClass('is-new-item')
      controller.set('model.newTask', false)
      return unless controller.get('parentController') instanceof Radium.TaskListItemController

      return if controller.get('parentController.parentController.hiddenContent.length')

      Ember.run.scheduleOnce 'afterRender', this, 'scrollToTask'
    , 100)

  scrollToTask: ->
    return unless @$()

    top = @$().offset().top + 200

    Ember.$("body,html").animate
      scrollTop: top,
        duration: 500
        complete: =>
          @set('controller.isExpanded', true) if @get('controller')
