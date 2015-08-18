require 'forms/form'

Radium.TodoForm = Radium.Form.extend
  data: (Ember.computed ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
  ).volatile()

  type: Ember.computed ->
    Radium.Todo

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
    self = this

    return new Ember.RSVP.Promise (resolve, reject) =>
      return resolve() unless @get('isNew')

      record = @get('type').createRecord @get('data')

      record.one 'didCreate', (created) ->
        created.set 'newTask', true
        text = "The task #{created.get("description")} has been created."
        result = {todo: created, confirmtation: text}
        if self.get('modal')
          self.get('closeFunc')()

        Ember.run.next ->
          if user = created?.get('user')
            user.reload()

        resolve(result)

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
            resolve(confirmation: "The todos have been created")

        record.one 'becameInvalid', (result) ->
          reject(result)

        record.one 'becameError', (result)  ->
          reject("An error has occurred and the #{typeName} could not be created.")

      @get('store').commit()
