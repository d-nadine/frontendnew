Radium.MessagesSidebarController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  needs: ['messages']
  page: 0
  loadedPages: Ember.A()
  allPagesLoaded: false

  actions:
    showMore: ->
      superMethod = @_super
      args = Array.prototype.slice.call(arguments)
      self = this
      loadedPages = @get('loadedPages')
      page = @get('page')
      allPagesLoaded = @get('allPagesLoaded')

      if allPagesLoaded || (loadedPages.indexOf(page) >= 0)
        superMethod.apply self, args
        return

      @set('page', page + 1)

      Radium.Email.find(user_id: @get('currentUser.id'), page: @get('page'), page_size: 14).then (emails) =>
        messagesProxy = @get('content.content')
        unless messagesProxy.get('initialSet')
          messagesProxy.set('initialSet', true)

        return unless emails.get('length')

        messagesProxy.add(emails)
        superMethod.apply self, args
        loadedPages.pushObject(page)
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

  currentTab: 'folderTabView'
  selectTab: (tab) ->
    @set 'currentTab', "#{tab}View"

  itemController: 'messagesSidebarItem'
