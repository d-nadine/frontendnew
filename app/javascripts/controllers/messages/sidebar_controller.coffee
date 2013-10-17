Radium.MessagesSidebarController = Radium.ArrayController.extend
  needs: ['messages']
  activeTab: 'inbox'
  page: 1
  allPagesLoaded: false

  inboxIsActive: Ember.computed.equal('activeTab', 'inbox')
  radiumIsActive: Ember.computed.equal('activeTab', 'radium')
  searchIsActive: Ember.computed.equal('activeTab', 'search')

  actions:
    showMore: ->
      return if @get('allPagesLoaded')

      @set('isLoading', true)

      page = @get('page') + 1

      console.log page

      @set('page', page)

      Radium.Email.find(user_id: @get('currentUser.id'), page: page, page_size: 10).then (emails) =>
        messagesProxy = @get('content')
        unless messagesProxy.get('initialSet')
          messagesProxy.set('initialSet', true)

        return unless emails.get('length')

        messagesProxy.pushObjects(emails.toArray())
        meta = emails.store.typeMapFor(Radium.Email).metadata
        @set('totalRecords', meta.totalRecords)
        @set('allPagesLoaded', meta.isLastPage)
        @set('isLoading', false)

    reset: ->
      @set('page', 1)
      @set('allPagesLoaded', false)

  folders: Ember.computed.alias 'controllers.messages.folders'
  folder: Ember.computed.alias 'controllers.messages.folder'

  isSearchOpen: false

  toggleSearch: ->
    @toggleProperty 'isSearchOpen'

  content: Ember.computed.alias 'controllers.messages'
  selectedContent: Ember.computed.alias 'controllers.messages.selectedContent'
  totalRecords: Ember.computed.alias 'controllers.messages.content.totalRecords'
  itemController: 'messagesSidebarItem'
