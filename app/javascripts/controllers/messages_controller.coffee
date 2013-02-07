Radium.MessagesController = Em.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  sortProperties: ['sentAt']
  emails: Ember.A()
  discussions: Ember.A()

  folders: [
    {title: 'Inbox', name: 'inbox'}
    {title: 'Sent items', name: 'sent'}
    {title: 'Attachments', name: 'attachments'}
    {title: 'Meeting Invitations', name: 'discussions'}
    {title: 'Clients', name: 'clients'}
    {title: 'Opportunities', name: 'opportunities'}
    {title: 'Leads', name: 'leads'}
    {title: 'Prospects', name: 'prospects'}
  ]

  folderDidChange: ( ->
    @set('emails', Radium.Email.find folder: @get('folder'))
    @set('discussions', Radium.Discussion.find folder: @get('folder'))
  ).observes('folder')

  items: (->
    items = []

    @get('discussions').forEach (discussion) -> items.pushObject discussion
    @get('emails').forEach (email) -> items.pushObject email

    items
  ).property('emails', 'emails.length', 'messages', 'messages.length')

  deleteItem: (item) ->
    item.set 'isChecked'
    # FIXME: ember-data association errors, fake for now
    # store = @get('store')

    # email.deleteRecord()
    # store.commit()

    @removeObject(item)
    Radium.Utils.notify "deleted."

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
