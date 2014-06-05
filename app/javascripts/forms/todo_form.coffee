require 'forms/form'

Radium.TodoForm = Radium.Form.extend
  data: (Ember.computed ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
  ).volatile()

  type: Ember.computed ->
    if this.constructor is Radium.TodoForm then Radium.Todo else Radium.Call

  reset: ->
    @_super.apply this, arguments
    @set 'description', ''
    @set('submitForm', false)

  isBulk: Ember.computed 'reference', ->
    Ember.isArray @get('reference')

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

    record.one 'didCreate', (result) =>
      result.set 'newTask', true
      deferred.resolve()

    record.one 'becameInvalid', (result) =>
      result.reset()
      deferred.reject(result)

    record.one 'becameError', (result)  ->
      result.reset()
      result.get('transaction').rollback()
      deferred.reject("An error has occurred and the #{result.get('typeName')} could not be created.")

  bulkCommit: (deferred) ->
    typeName = @get('reference.firstObject').humanize()

    @get('reference').forEach (item) =>
      record = @get('type').createRecord @get('data')
      record.set 'reference', item

      record.one 'didCreate', (record) =>
        if item == @get('reference.lastObject')
          deferred.resolve("The todos have been created")

      record.one 'becameInvalid', (result) =>
        deferred.reject(result)

      record.one 'becameError', (result)  ->
        deferred.reject("An error has occurred and the #{typeName} could not be created.")
