Radium.EmailsController = Em.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  folders: [
    {label: 'Inbox', name: 'inbox'}
    {label: 'Sent items', name: 'sent'}
    {label: 'Attachments', name: 'attachments'}
    {label: 'Meeting Invitations', name: 'meetings'}
    {label: 'Clients', name: 'clients'}
    {label: 'Opportunities', name: 'opportunities'}
    {label: 'Leads', name: 'leads'}
    {label: 'Prospects', name: 'prospects'}
  ]

  arrangedContent: (->
    Radium.Email.find folder: @get('folder')
  ).property('folder')

  history: (->
    return unless @get('selectedContent')
    Radium.Email.find historyFor: @get('selectedContent')
  ).property('selectedContent')

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
