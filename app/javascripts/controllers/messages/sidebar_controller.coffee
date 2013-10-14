Radium.MessagesSidebarController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  needs: ['messages']
  page: 1
  loadedPages: Ember.A()

  actions:
    showMore: ->
      superMethod = @_super
      args = Array.prototype.slice.call(arguments)
      self = this
      @set('page', @get('page') + 1)
      page = @get('page')
      loadedPages = @get('loadedPages')

      Radium.Email.find(user_id: @get('currentUser.id'), page: page).then (emails) =>
        @get('content.content').add(emails)
        superMethod.apply self, args
        # loadedPages.pushObject(page)

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
