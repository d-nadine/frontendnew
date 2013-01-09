Radium.InboxController = Em.ArrayController.extend
  selectedMail: ( ->
    @filter (email) -> email.get('isSelected')
  ).property('@each.isSelected')
  deselectEmail: (event) ->
    event.context.set('isSelected', false)
  createTodo: (data, email) ->
    todo = Radium.Todo.createRecord(data)
    todo.set('reference', email)
    todo.store.commit()

    #TODO Radium.get('router.activeFeedController').pushHitem todo

  markRead: (state) ->
    @markEmailRead(true)

  markUnread: (state) ->
    @markEmailRead(false)

  markEmailRead: (isRead) ->
    selected = @get('selectedMail')
    return if selected.get('length') == 0

    selected.forEach (email) ->
      email.set('read', isRead) unless email.get('read') == isRead

    @get('store').commit()

  deleteEmails: ->
    count = @get('selectedMail.length')
    #FIXME ember-data association errors
    # @get('selectedMail').toArray().forEach (email) ->
    #   email.deleteRecord()
    # @get('store').commit()

    @removeObjects(@get('selectedMail'))

    Radium.Utils.notify "#{count} emails deleted."
