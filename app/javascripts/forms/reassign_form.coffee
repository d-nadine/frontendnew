require 'forms/form'

Radium.ReassignForm = Radium.Form.extend
  data: ( ->
    user: @get('assignToUser')
    finishBy: @get('finishBy')
    description: @get('todo')
  ).property().volatile()

  isValid: ( ->
    @get('assignToUser')
  ).property('assignToUser')

  reset: ->
    @_super.apply this, arguments
    @set('todo', null)

  commit: ->
    @get('selectedContent').forEach (item) =>
      item.set('user', @get('assignToUser'))

      unless Ember.isEmpty @get('todo')
        todo = Radium.Todo.createRecord @get('data')
        todo.set 'reference', item

    @get('store').commit()
