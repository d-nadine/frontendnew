Radium.FlashNewViewMixin = Ember.Mixin.create
  setup: Ember.on 'didInsertElement', ->
    if @get('controller.newTask')
      @observeNewTask()
    else
      @addObserver 'controller.newTask', this, 'observeNewTask'

  tearDown: Ember.on 'willDestroyElement', ->
    @removeObserver 'controller.newTask', this, 'observeNewTask'

  observeNewTask: ->
    controller = @get('controller')

    return unless controller.get('newTask')

    @$().addClass('is-new-item')

    Ember.run.later(this, =>
      @$()?.removeClass('is-new-item')

      @removeObserver 'controller.newTask', this, 'observeNewTask'

      controller.set('model.newTask', false)

      return unless controller.get('parentController') instanceof Radium.TaskListItemController

      return if controller.get('parentController.parentController.hiddenContent.length')

      Ember.run.scheduleOnce 'afterRender', this, 'scrollToTask'
    , 1000)

  scrollToTask: ->
    return unless @$()

    top = @$().offset().top - 100

    Ember.$("body,html").animate
      scrollTop: top,
        duration: 500
        complete: =>
          unless controller = @get('controller')
            return

          return if controller.isDestroyed

          controller.set('isExpanded', true) if @get('controller')
