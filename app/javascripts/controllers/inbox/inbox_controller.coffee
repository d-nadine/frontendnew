Radium.InboxController = Em.ArrayController.extend
  selectedMail: ( ->
    Em.ArrayProxy.create Ember.FilterableMixin,
      context: this
      contentBinding: 'context.content'
      filterProperties: ['isSelected']
  ).property('content')

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

  createTodo: (data, email) ->
    todo = Radium.Todo.createRecord(data)
    todo.set('reference', email)
    todo.store.commit()

    #TODO Radium.get('router.activeFeedController').pushHitem todo

  deleteEmails: ->
    selected = @get('content').filter (email) -> email.get('isSelected')

    return if selected.get('count') == 0

    count = selected.get('length')
    #FIXME ember-data association errors
    # @get('selectedMail').toArray().forEach (email) ->
    #   email.deleteRecord()
    # @get('store').commit()
    selected.forEach (email) -> email.set('isSelected', false)

    @removeObjects(selected)

    Radium.Utils.notify "#{count} emails deleted."
