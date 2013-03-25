Radium.MessagesController = Em.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  sortProperties: ['sentAt']
  folderBinding: 'model.folder'

  folders: [
    { title: 'Inbox', name: 'inbox' }
    { title: 'Sent items', name: 'sent' }
    { title: 'Discussions', name: 'discussions' }
    { title: 'All Emails', name: 'emails' }
    { title: 'Untracked', name: 'untracked' }
  ]

  canSelectItems: (->
    @get('checkedContent.length') == 0
  ).property('checkedContent.length')

  noSelection: (->
    return false if @get('selectedContent')
    return false if @get('hasCheckedContent')
    true
  ).property('hasCheckedContent', 'selectedContent')

  clear: ->
    @get('content').clear()

  load: ->
    @get('content').load()
