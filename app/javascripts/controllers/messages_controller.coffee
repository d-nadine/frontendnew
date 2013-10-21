require 'mixins/controllers/poller_mixin'

Radium.MessagesController = Radium.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin, Radium.PollerMixin,
  folder: "inbox"
  pageSize: 5
  needs: ['application', 'messagesSidebar']
  applicationController: Ember.computed.alias 'controllers.application'
  isLoading: Ember.computed.alias 'controllers.messagesSidebar.isLoading'

  folders: [
    { title: 'Inbox', name: 'inbox', icon: 'mail' }
    { title: 'Sent items', name: 'sent', icon: 'send' }
    # { title: 'Discussions', name: 'discussions', icon: 'chat' }
    # { title: 'All Emails', name: 'emails', icon: 'mail' }
    # { title: 'Attachments', name: 'attachments', icon: 'attach' }
    # { title: 'Meeting invites', name: 'invites', icon: 'calendar' }
  ]

  onPoll: ->
    currentPath = @get('controllers.application.currentPath')

    return if currentPath is 'messages.bulk_actions'

    queryParams = @queryParams()

    Radium.Email.find(queryParams).then (emails) =>
      return if currentPath is 'messages.bulk_actions'
      return if @get('isLoading')

      newEmails = @delta(emails)

      return unless newEmails.length

      console.log "#{newEmails.length} found"

      @tryAdd(newEmails)

      meta = emails.store.typeMapFor(Radium.Email).metadata

      @set('totalRecords', meta.totalRecords)

    Radium.Discussion.find({}).then (discussions) =>
      return if currentPath is 'messages.bulk_actions'
      return if @get('folder') == "sent"

      newDiscussions = @delta(discussions)

      return unless discussions.length

      @tryAdd(newDiscussions) if newDiscussions.length

  tryAdd: (items) ->
    content = @get('content')
    ids = content.map (item) -> item.get('id')
    folder = @get('folder')
    currentUser = @get('currentUser')

    items.toArray().forEach (item) =>
      return if ids.contains(item.get('id'))
      return if folder == "sent" && item.get('sender') != currentUser
      return if folder == "radium" && item is Radium.Emal && item.get('isPersonal')
      @unshiftObject(item)
      ids.push item.get('id')

  delta: (records) ->
    delta = records.toArray().reject (record) =>
                @get('content').contains(record)

    delta

  canSelectItems: (->
    @get('checkedContent.length') == 0
  ).property('checkedContent.length')

  noSelection: (->
    return false if @get('selectedContent')
    return false if @get('hasCheckedContent')
    true
  ).property('hasCheckedContent', 'selectedContent')

  queryFolders:
    inbox: "INBOX"
    sent: "Sent Messages"

  queryParams: ->
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
