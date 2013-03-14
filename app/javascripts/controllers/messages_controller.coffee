Radium.MessagesController = Em.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  sortProperties: ['sentAt']
  folderBinding: 'model.folder'

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

  destroy: ->
    console.log 'weee'

  # deleteItem: (item) ->
  #   item.set 'isChecked'
  #   # FIXME: ember-data association errors, fake for now
  #   # store = @get('store')

  #   # email.deleteRecord()
  #   # store.commit()

  #   @removeObject(item)
  #   Radium.Utils.notify "deleted."

  # deleteEmails: ->
  #   return if selected.get('count') == 0

  #   count = selected.get('length')
  #   # FIXME: ember-data association errors, fake for now
  #   # @get('selectedMail').toArray().forEach (email) ->
  #   #   email.deleteRecord()
  #   # @get('store').commit()
  #   selected.forEach (email) -> email.set('isSelected', false)

  #   @removeObjects(selected)

  #   Radium.Utils.notify "#{count} emails deleted."

  canSelectItems: (->
    @get('checkedContent.length') == 0
  ).property('checkedContent.length')

  history: (->
    return unless @get('selectedContent')
    Radium.Email.find historyFor: @get('selectedContent')
  ).property('selectedContent')

  showDiscussion: (->
    return if @get('hasCheckedContent')
    @get('selectedContent') instanceof Radium.Discussion
  ).property('hasCheckedContent', 'selectedContent')

  showEmails: (->
    return if @get('hasCheckedContent')
    @get('selectedContent') instanceof Radium.Email
  ).property('hasCheckedContent', 'selectedContent')

  noSelection: (->
    return false if @get('selectedContent')
    return false if @get('hasCheckedContent')
    true
  ).property('hasCheckedContent', 'selectedContent')
