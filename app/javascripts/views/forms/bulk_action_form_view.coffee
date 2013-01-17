require 'radium/views/forms/tasks_view'

Radium.BulkActionsTaskView = Radium.TasksView.extend
  init: ->
    @_super.apply this, arguments
    @get('buttons').insertAt 0,
      Ember.Object.create
       action: "delete"
       label: "Delete"
       closed: true

