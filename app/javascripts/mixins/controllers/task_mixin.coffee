Radium.TaskMixin = Ember.Mixin.create
  showMeetingForm: Ember.computed 'model', ->
    @get('model.constructor') is Radium.Meeting

  showTodoForm: Ember.computed 'model', ->
    @get('model.constructor') is Radium.Todo

  showCallForm: Ember.computed 'model', ->
    @get('model.constructor') is Radium.Call
