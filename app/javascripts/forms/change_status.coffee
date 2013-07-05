require 'forms/form'

Radium.ChangeStatusForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    status: @get('status')
    description: @get('todo')
    lostBecause: @get('lostBecause')
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
    @get('deals').setEach 'isChecked', false

  commit:  ->
    promise = Ember.Deferred.promise (deferred) =>
      deferred.resolve() unless @get('deals.length')

      transaction = @get('store').transaction()

      @get('deals').forEach (item) =>
        if @get('status').toLowerCase() == 'lost'
          item.set('lostDuring', item.get('status'))
          item.set('lostBecause', @get('lostBecause'))
        else
          item.set('lostDuring', null)
          item.set('lostBecause', null)

        item.set('status', @get('status'))

        unless Ember.isEmpty @get('todo')
          todo = Radium.Todo.createRecord @get('data')
          todo.set 'reference', item

        item.one 'didUpdate', =>
          deferred.resolve() unless @get('deals.length')

        item.one 'becameInvalid', (result) =>
          Radium.Utils.generateErrorSummary deal
          transaction.rollback()
          deferred.reject()

        item.one 'becameError', (result)  ->
          Radium.Utils.notifyError 'An error has occurred and the deal could not be created.'
          transaction.rollback()
          deferred.reject()

        transaction.add item

      transaction.commit()

    promise
