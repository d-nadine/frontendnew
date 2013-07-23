require 'forms/form'

Radium.ReassignForm = Radium.Form.extend
  data: ( ->
    user: @get('assignToUser')
    finishBy: @get('finishBy')
    description: @get('todo')
  ).property().volatile()

  isValid: ( ->
    @get('assignToUser')
  ).property('assignToUser')

  reset: ->
    @_super.apply this, arguments
    @set('todo', null)

  commit: ->
    promise = Ember.Deferred.promise (deferred) =>
      deferred.resolve() unless @get('selectedContent.length')

      transaction = @get('store').transaction()

      @get('selectedContent').forEach (deal) =>
        deal.set('user', @get('assignToUser'))

        unless Ember.isEmpty @get('todo')
          todo = Radium.Todo.createRecord @get('data')
          todo.set 'reference', deal
          transaction.add todo

        deal.one 'didUpdate', =>
          deal.set 'isChecked', false
          deferred.resolve() unless @get('deals.length')

        deal.one 'becameInvalid', (result) =>
          transaction.rollback()
          deferred.reject(result)

        deal.one 'becameError', (result)  ->
          transaction.rollback()
          deferred.reject('An error has occurred and the deals could not be reassigned.')

        transaction.add deal

      transaction.commit()

    promise
