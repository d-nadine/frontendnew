Radium.MessagesController = Em.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  sortProperties: ['sentAt']

  folders: [
    {title: 'Inbox', name: 'inbox'}
    {title: 'Sent items', name: 'sent'}
    {title: 'Attachments', name: 'attachments'}
    {title: 'Meeting Invitations', name: 'meetings'}
    {title: 'Clients', name: 'clients'}
    {title: 'Opportunities', name: 'opportunities'}
    {title: 'Leads', name: 'leads'}
    {title: 'Prospects', name: 'prospects'}
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
