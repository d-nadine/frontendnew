Radium.TaskMixin = Ember.Mixin.create
  showMeetingForm: (->
    @get('model.constructor') is Radium.Meeting
  ).property('model')

  showTodoForm: (->
    @get('model.constructor') is Radium.Todo
  ).property('model')

  showCallForm: (->
    @get('model.constructor') is Radium.Call
  ).property('model')
