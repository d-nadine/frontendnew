Radium.CalendarTaskItemController = Radium.ObjectController.extend
  actions:
    finishTask: ->
      model = @get('model.model')

      return unless model.constructor is Radium.Todo

      @toggleProperty 'isFinished'

      Ember.run =>
        if @get("controllers.application.currentPath") == "calendar.task"
          model.set('isExpanded', !model.get('isFinished'))
        else
          model.set('isExpanded', false)

      @get('store').commit()

  needs: ['calendarSidebar']

  selectedTask: Ember.computed.alias 'controllers.calendarSidebar.selectedTask'

  isSelected: ( ->
    @get('selectedTask') == @get('model.model')
  ).property('selectedTask')
