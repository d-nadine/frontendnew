Radium.InboxController = Em.ArrayController.extend Radium.CheckableMixin,
  history: (->
    return unless @get('selectedObject')
    Radium.Email.find historyFor: @get('selectedObject')
  ).property('selectedObject')

  selectObject: (event) ->
    email = event.context
    @set 'selectedObject', email

  createTodo: (data, email) ->
    todo = Radium.Todo.createRecord(data)
    todo.set 'reference', email
    todo.store.commit()

  deleteEmail: (email) ->
    email.set 'isChecked'
    # FIXME: ember-data association errors, fake for now
    # store = @get('store')

    # email.deleteRecord()
    # store.commit()

    @removeObject(email)
    Radium.Utils.notify "email deleted."

  deleteEmails: ->
    return if selected.get('count') == 0

    count = selected.get('length')
    # FIXME: ember-data association errors, fake for now
    # @get('selectedMail').toArray().forEach (email) ->
    #   email.deleteRecord()
    # @get('store').commit()
    selected.forEach (email) -> email.set('isSelected', false)

    @removeObjects(selected)

    Radium.Utils.notify "#{count} emails deleted."
