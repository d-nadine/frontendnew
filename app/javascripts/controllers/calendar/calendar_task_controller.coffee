Radium.CalendarTaskController = Ember.ObjectController.extend Radium.TaskMixin,
  needs: ['calendarSidebar']

  modelWillChange: Ember.beforeObserver 'model', ->
    @set('model.isExpanded', false)
