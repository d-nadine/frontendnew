Radium.CalendarDateTaskItemView = Ember.View.extend Radium.FlashNewViewMixin,
  tagName: 'li'
  classNames: ['day-event-item']
  classNameBindings: ['controller.isSelected']
  templateName: 'calendar/date_task_item'
