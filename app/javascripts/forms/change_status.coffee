require 'forms/form'

Radium.ChangeStatusForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    status: @get('status')
    description: @get('todo')
  ).property().volatile()

  isValid: ( ->
    if @get('status').toLowerCase() == 'lost' && !@get('lostBecause.length')
      return false
    @get('status')
  ).property('status', 'lostBecause')

  reset: ->
    @_super.apply this, arguments
    @set('todo', null)
    @set('lostBecause', null)

  commit:  ->
    promise = Ember.Deferred.promise (deferred) =>
      deferred.resolve() unless @get('deals.length')

      transaction = @get('store').transaction()

      @get('deals').forEach (deal) =>
        if @get('status').toLowerCase() == 'lost'
          deal.set('lostDuring', deal.get('status'))
          deal.set('lostBecause', @get('lostBecause'))
        else
          deal.set('lostDuring', null)
          deal.set('lostBecause', null)

        deal.set('status', @get('status'))

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
          deferred.reject('An error has occurred and the selected deals status could not be changed.')

        transaction.add deal

      transaction.commit()

    promise
