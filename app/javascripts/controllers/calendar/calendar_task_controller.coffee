Radium.CalendarTaskController = Ember.ObjectController.extend Radium.TaskMixin,
  modelWillChange: Ember.beforeObserver 'model', ->
    @set('model.isExpanded', false)
