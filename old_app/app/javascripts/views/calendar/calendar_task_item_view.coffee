Radium.CalendarTaskItemView = Radium.View.extend Radium.FlashNewViewMixin,
  classNames: 'events-list-item'
  classNameBindings: ['controller.isSelected']
  templateName: 'calendar/calendar_task_item'

  isSelectedDidChange: Ember.observer 'controller.isSelected', ->
    return unless @get('controller.isSelected')

    Ember.run.scheduleOnce 'afterRender', this, 'scrollToTask'

  scrollToTask: ->
    return unless @$()

    parent = Ember.$('.sidebar')

    distanceToCenter = (0.5 * parent.height() - @$().outerHeight())
    return unless @$().offset()
    distanceToElement = @$().offset().top

    top = distanceToElement - distanceToCenter
    top = 0 if top < 0

    Ember.$(".sidebar").animate(scrollTop: top , 300)
