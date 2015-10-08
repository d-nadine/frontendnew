Radium.CalendarTaskItemController = Radium.ObjectController.extend
  needs: ['calendarSidebar']

  selectedTask: Ember.computed.alias 'controllers.calendarSidebar.selectedTask'

  isSelected: Ember.computed 'selectedTask', ->
    @get('selectedTask') == @get('model.model')
