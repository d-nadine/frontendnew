Radium.MessagesController = Radium.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  sortProperties: ['time']
  sortAscending: false

  folderBinding: 'model.folder'

  folders: [
    { title: 'Inbox', name: 'inbox' }
    { title: 'Sent items', name: 'sent' }
    { title: 'Discussions', name: 'discussions' }
    { title: 'All Emails', name: 'emails' }
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

  selectedSearchScope: "Search All Emails"