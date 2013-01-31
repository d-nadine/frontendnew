Radium.MessagesController = Em.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  sortProperties: ['sentAt']

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

  content: (->
    Radium.Email.find folder: @get('folder')
  ).property('folder')

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
