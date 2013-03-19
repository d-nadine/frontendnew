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

  canSelectItems: (->
    @get('checkedContent.length') == 0
  ).property('checkedContent.length')

  noSelection: (->
    return false if @get('selectedContent')
    return false if @get('hasCheckedContent')
    true
  ).property('hasCheckedContent', 'selectedContent')
