require 'forms/form'

Radium.ChangeStatusForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    status: @get('status')
    description: @get('todo')
  ).property().volatile()

  isValid: ( ->
    @get('status')
  ).property('status')

  reset: ->
    @_super.apply this, arguments
    @set('todo', null)
    @get('deals').setEach 'isChecked', false

  commit: ->
    @get('deals').forEach (item) =>
      item.set('status', @get('status'))

      unless Ember.isEmpty @get('todo')
        todo = Radium.Todo.createRecord @get('data')
        todo.set 'reference', item

    @get('store').commit()
