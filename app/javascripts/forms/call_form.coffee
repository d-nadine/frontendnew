require 'forms/todo_form'

Radium.CallForm = Radium.TodoForm.extend
  canChangeContact: true

  type: ( ->
    Radium.Call
  ).property()

  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
    contact: @get('contact')
  ).property().volatile()

  isValid: (->
    return unless @_super()

    return if !@get('contact') && !@get('isBulk')

    if @get('isBulk') && @get('reference.length') && @get('reference').some((item) -> item.constructor is Radium.Contact)
      return true

    true
  ).property('contact', 'description', 'finishBy', 'user')

  bulkCommit: ->
    @get('reference').forEach (item) =>
      contact = if @get('contact')
                  contact
                else if item.constructor is Radium.Contact
                  item
                else if item.get('contact')
                  item.get('contact')

      if contact
        record = @get('type').createRecord @get('data')

        if !record.get('contact') && item.constructor is Radium.Contact
          record.set('contact', item)
        else
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
