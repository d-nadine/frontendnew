require 'forms/form'

Radium.TodoForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
  ).property().volatile()

  isValid: ( ->
    return if Ember.isEmpty(@get('description'))
    return if @get('finishBy').isBeforeToday()
    return unless @get('user')

    true
  ).property('description', 'finishBy', 'user')

  commit: ->
    isBulk = Ember.isArray @get('reference')

    if isBulk
      @bulkCommit()
    else
      @individualCommit()

    @get('store').commit()

  individualCommit: ->
    return unless @get('isNew')

    Radium.Todo.createRecord @get('data')

  bulkCommit: ->
    @get('reference').forEach (item) =>
      todo = Radium.Todo.createRecord @get('data')
      todo.set 'reference', item
