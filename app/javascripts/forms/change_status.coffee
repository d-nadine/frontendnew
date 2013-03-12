require 'forms/form'

Radium.ChangeStatusForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    status: @get('status')
    description: @get('statusTodo')
  ).property().volatile()

  isValid: ( ->
    @get('status')
  ).property('status')

  reset: ->
    @_super.apply this, arguments
    @set('statusTodo', null)

  commit: ->
    @get('deals').forEach (item) =>
      item.set('status', @get('status'))

      unless Ember.isEmpty @get('statusTodo')
        todo = Radium.Todo.createRecord @get('data')
        todo.set 'reference', item

    @get('store').commit()
