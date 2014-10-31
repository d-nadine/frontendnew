require 'forms/form'

Radium.ReassignForm = Radium.Form.extend
  data: ( ->
    user: @get('assignToUser')
    finishBy: @get('finishBy')
    description: @get('todo')
  ).property().volatile()

  isValid: Ember.computed 'assignToUser', ->
    @get('assignToUser')

  reset: ->
    @_super.apply this, arguments
    @set('todo', null)

  commit: ->
    return new Ember.RSVP.Promise (resolve, reject) =>
      resolve() unless @get('selectedContent.length')

      transaction = @get('store').transaction()

      @get('selectedContent').forEach (deal) =>
        deal.set('user', @get('assignToUser'))

        unless Ember.isEmpty @get('todo')
          todo = Radium.Todo.createRecord @get('data')
          todo.set 'reference', deal
          transaction.add todo

        deal.one 'didUpdate', =>
          deal.set 'isChecked', false
          resolve() unless @get('deals.length')

        deal.one 'becameInvalid', (result) =>
          transaction.rollback()
          reject(result)

        deal.one 'becameError', (result)  ->
          transaction.rollback()
          reject('An error has occurred and the deals could not be reassigned.')

        transaction.add deal

      transaction.commit()

    promise
