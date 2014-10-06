Radium.CalendarTaskController = Ember.ObjectController.extend Radium.TaskMixin,
  needs: ['calendarSidebar']

  modelDidChange: Ember.observer 'model', ->
    @set('model.isExpanded', false)
