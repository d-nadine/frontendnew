Radium.CalendarTaskItemController = Radium.ObjectController.extend
  needs: ['calendarSidebar']

  selectedTask: Ember.computed.alias 'controllers.calendarSidebar.selectedTask'

  isSelected: ( ->
    @get('selectedTask') == @get('model.model')
  ).property('selectedTask')
