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

  isBulk: ( ->
    Ember.isArray @get('reference')
  ).property('reference')

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
      result.get('transaction').rollback()
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
