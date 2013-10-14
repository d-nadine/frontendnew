Radium.MessagesSidebarController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  needs: ['messages']
  page: 1
  loadedPages: Ember.A()
  allPagesLoaded: false

  actions:
    showMore: ->
      superMethod = @_super
      args = Array.prototype.slice.call(arguments)
      self = this
      page = @get('page')
      loadedPages = @get('loadedPages')
      allPagesLoaded = @get('allPagesLoaded')

      @set('page', @get('page') + 1)

      if allPagesLoaded || (loadedPages.indexOf(page) >= 0)
        superMethod.apply self, args
        return

      Radium.Email.find(user_id: @get('currentUser.id'), page: page).then (emails) =>
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
