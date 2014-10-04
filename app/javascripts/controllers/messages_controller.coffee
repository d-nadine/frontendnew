require 'mixins/controllers/poller_mixin'

Radium.MessagesController = Radium.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin, Radium.PollerMixin,
  drawerOpen: false
  folder: "inbox"
  pageSize: 5
  needs: ['messagesSidebar']
  isLoading: Ember.computed.alias 'controllers.messagesSidebar.isLoading'
  currentPath: Ember.computed.alias 'controllers.application.currentPath'
  sortProperties: ['time']
  sortAscending: false

  folders: [
    { title: 'Inbox', name: 'inbox', icon: 'mail' }
    { title: 'Archive', name: 'archive', icon: 'box' }
    { title: 'Drafts', name: 'drafts', icon: 'file' }
    { title: 'Sent items', name: 'sent', icon: 'send' }
    { title: 'Scheduled', name: 'scheduled', icon: 'clock' }
  ]

  onPoll: ->
    currentPath = @get('currentPath')

    return if currentPath is 'messages.bulk_actions'

    requestParams = @requestParams()

    Radium.Email.find(requestParams).then (emails) =>
      return if currentPath is 'messages.bulk_actions'
      return if @get('isLoading')

      newEmails = @delta(emails)

      return unless newEmails.length

      console.log "#{newEmails.length} found"

      @tryAdd(newEmails)

      meta = emails.store.typeMapFor(Radium.Email).metadata

      @set('totalRecords', meta.totalRecords)

  tryAdd: (items) ->
    content = @get('content')
    ids = content.map (item) -> item.get('id')
    folder = @get('folder')
    currentUser = @get('currentUser')

    items.toArray().forEach (item) =>
      return if ids.contains(item.get('id'))
      return if folder == "sent" && item.get('sender') != currentUser
      return if folder == "radium" && item.constructor is Radium.Email && item.get('isPersonal')
      return if folder == "drafts" && item.constructor is Radium.Email && !item.get('isDraft')
      return if folder == "archive" && item.constructor is Radium.Email && !item.get('isArchived')

      @unshiftObject(item)
      ids.push item.get('id')

    if @get('currentPath') == "messages.emails.empty"
      Ember.run.next =>
        unless email = @get('firstObject')
          return email

        @send 'selectItem', @get('firstObject')

  delta: (records) ->
    delta = records.toArray().reject (record) =>
                @get('content').contains(record)

    delta

  canSelectItems: Ember.computed 'checkedContent.[]', ->
    @get('checkedContent.length') == 0

  noSelection: Ember.computed 'hasCheckedContent', 'selectedContent', ->
    return false if @get('selectedContent')
    return false if @get('hasCheckedContent')
    true

  queryFolders:
    inbox: "INBOX"
    archive: "archived"
    sent: "Sent Messages"
    drafts: "Drafts"
    scheduled: "Scheduled"

  requestParams: ->
    folder = @get('folder')
    queryFolder = @queryFolders[folder]
    pageSize = @get('pageSize')

    if folder == "radium"
      user_id: @get('currentUser.id')
      radium_only: true
      page: 1
      page_size: pageSize
    else
      user_id: @get('currentUser.id')
      folder: queryFolder
      page: 1
      page_size: pageSize
