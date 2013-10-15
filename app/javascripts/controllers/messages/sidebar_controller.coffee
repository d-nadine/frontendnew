Radium.MessagesSidebarController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  needs: ['messages']
  activeTab: 'inbox'
  page: 0
  loadedPages: Ember.A()
  allPagesLoaded: false

  inboxIsActive: Ember.computed.equal('activeTab', 'inbox')
  radiumIsActive: Ember.computed.equal('activeTab', 'radium')
  searchIsActive: Ember.computed.equal('activeTab', 'search')

  actions:
    showMore: ->
      superMethod = @_super
      args = Array.prototype.slice.call(arguments)
      self = this
      loadedPages = @get('loadedPages')
      page = @get('page')
      allPagesLoaded = @get('allPagesLoaded')

      unless allPagesLoaded
        @set('page', page + 1)
        page = @get('page')

      if allPagesLoaded || (loadedPages.indexOf(page) >= 0)
        superMethod.apply self, args
        @send('loadNextPage') if (!allPagesLoaded) && (loadedPages.indexOf(page + 1) == -1)
        return

      loadedPages.pushObject(page)

      Radium.Email.find(user_id: @get('currentUser.id'), page: page, page_size: 10).then (emails) =>
        messagesProxy = @get('content.content')
        unless messagesProxy.get('initialSet')
          messagesProxy.set('initialSet', true)

        return unless emails.get('length')

        messagesProxy.add(emails)
        superMethod.apply self, args
        meta = emails.store.typeMapFor(Radium.Email).metadata
        @set('allPagesLoaded', meta.isLastPage)

        @send('loadNextPage') if (!meta.isLastPage) && (loadedPages.indexOf(page + 1) == -1)

    loadNextPage: ->
      page = @get('page') + 1

      @set('page', page)

      loadedPages = @get('loadedPages')

      return unless loadedPages.indexOf(page) == -1

      loadedPages.pushObject(page)

      Radium.Email.find(user_id: @get('currentUser.id'), page: page, page_size: 10).then (emails) =>
        messagesProxy = @get('content.content')

        return unless emails.get('length')

        messagesProxy.add(emails)
        @get('loadedPages').pushObject(page)
        meta = emails.store.typeMapFor(Radium.Email).metadata
        @set('allPagesLoaded', meta.isLastPage)

  folders: Ember.computed.alias 'controllers.messages.folders'
  folder: Ember.computed.alias 'controllers.messages.folder'

  isSearchOpen: false

  toggleSearch: ->
    @toggleProperty 'isSearchOpen'

  content: Ember.computed.alias 'controllers.messages'
  selectedContent: Ember.computed.alias 'controllers.messages.selectedContent'
  totalRecords: Ember.computed.alias 'controllers.messages.content.totalRecords'
  itemController: 'messagesSidebarItem'
