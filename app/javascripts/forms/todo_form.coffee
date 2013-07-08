require 'forms/form'

Radium.TodoForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
  ).property().volatile()

  reset: ->
    @_super.apply this, arguments
    @set 'description', ''

  isValid: ( ->
    return if Ember.isEmpty(@get('description'))
    return if @get('finishBy').isBeforeToday()
    return unless @get('user')

    true
  ).property('description', 'finishBy', 'user')

  commit: ->
    promise = Ember.Deferred.promise (deferred) =>
      isBulk = Ember.isArray @get('reference')

      if isBulk
        @bulkCommit(deferred)
      else
        @individualCommit(deferred)

      @get('store').commit()

    promise

  individualCommit: (deferred) ->
    return unless @get('isNew')

    todo = Radium.Todo.createRecord @get('data')

    todo.one 'didCreate', =>
      deferred.resolve()

    todo.one 'becameInvalid', (result) =>
      Radium.Utils.generateErrorSummary result
      deferred.reject()

    todo.one 'becameError', (result)  ->
      Radium.Utils.notifyError 'An error has occurred and the todo could not be created.'
      deferred.reject()

  bulkCommit: ->
    @get('reference').forEach (item) =>
      todo = Radium.Todo.createRecord @get('data')
      todo.set 'reference', item

    todo.one 'didCreate', (todo) =>
      if item == @get('reference.lastObject')
        deferred.resolve()

    todo.one 'becameInvalid', (result) =>
      Radium.Utils.generateErrorSummary result
      deferred.reject()

    todo.one 'becameError', (result)  ->
      Radium.Utils.notifyError 'An error has occurred and the todo could not be created.'
      deferred.reject()
