require 'forms/form'

Radium.ReassignForm = Radium.Form.extend
  data: ( ->
    user: @get('assignToUser')
    finishBy: @get('finishBy')
    description: @get('reassignTodo')
  ).property().volatile()

  isValid: ( ->
    @get('assignToUser')
  ).property('user')

  commit: ->
    @get('selectedContent').forEach (item) =>
      item.set('user', @get('assignToUser'))

      unless Ember.isEmpty @get('reassignTodo')
        todo = Radium.Todo.createRecord @get('data')
        todo.set 'reference', item

    @get('store').commit()
