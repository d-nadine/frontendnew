require 'forms/form'

Radium.TodoForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
  ).property().volatile()

  type: ( ->
    Radium.Todo
  ).property()

  typeName: ( ->
    @get('type').toString().humanize()
  ).property('type')

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

    record = @get('type').createRecord @get('data')

    record.one 'didCreate', =>
      deferred.resolve()

    record.one 'becameInvalid', (result) =>
      Radium.Utils.generateErrorSummary result
      deferred.reject()

    record.one 'becameError', (result)  ->
      Radium.Utils.notifyError "An error has occurred and the #{@get('typeName')} could not be created."
      deferred.reject()

  bulkCommit: ->
    @get('reference').forEach (item) =>
      record = @get('type').createRecord @get('data')
      record.set 'reference', item

      record.one 'didCreate', (record) =>
        if item == @get('reference.lastObject')
          deferred.resolve()

      record.one 'becameInvalid', (result) =>
        Radium.Utils.generateErrorSummary result
        deferred.reject()

      record.one 'becameError', (result)  ->
        Radium.Utils.notifyError "An error has occurred and the #{@get('typeName')} could not be created."
        deferred.reject()
