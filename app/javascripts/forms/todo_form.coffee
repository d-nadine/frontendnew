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
    isBulk = Ember.isArray @get('reference')

    if isBulk
      return @bulkCommit()
    else
      return @individualCommit()

  individualCommit: (deferred) ->
    return new Ember.RSVP.Promise (resolve, reject) =>
      return resolve() unless @get('isNew')

      record = @get('type').createRecord @get('data')

      record.one 'didCreate', (result) ->
        result.set 'newTask', true
        resolve("The task #{result.get("description")} has been created.")

      record.one 'becameInvalid', (result) ->
        reject(result)

      record.one 'becameError', (result)  ->
        reject("An error has occurred and the #{result.get('typeName')} could not be created.")

      @get('store').commit()

  bulkCommit: ->
    return new Ember.RSVP.Promise (resolve, reject) =>
      typeName = @get('reference.firstObject').humanize()

      @get('reference').forEach (item) =>
        record = @get('type').createRecord @get('data')
        record.set 'reference', item

        record.one 'didCreate', (record) =>
          if item == @get('reference.lastObject')
            resolve("The todos have been created")

        record.one 'becameInvalid', (result) =>
          reject(result)

        record.one 'becameError', (result)  ->
          reject("An error has occurred and the #{typeName} could not be created.")

      @get('store').commit()