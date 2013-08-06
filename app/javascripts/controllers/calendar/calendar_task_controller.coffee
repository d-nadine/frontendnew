Radium.CalendarTaskController = Ember.ObjectController.extend Radium.TaskMixin,
  modelDidChagne: ( ->
    model = @get('model')

    return unless model

    model.set 'isExpanded', true
  ).observes('model')
