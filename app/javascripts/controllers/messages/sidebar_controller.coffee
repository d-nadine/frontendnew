Radium.MessagesSidebarController = Radium.ArrayController.extend Radium.InfiniteScrollControllerMixin,
  needs: ['messages', 'emailsShow', 'messagesDiscussion']
  page: 1
  allPagesLoaded: false
  loadingType: Radium.Email

  currentPath: Ember.computed.alias 'controllers.application.currentPath'
  content: Ember.computed.alias 'controllers.messages'
  selectedContent: Ember.computed.alias 'controllers.messages.selectedContent'
  totalRecords: Ember.computed.alias 'controllers.messages.content.totalRecords'
  folder: Ember.computed.alias 'controllers.messages.folder'
  itemController: 'messagesSidebarItem'

  inboxIsActive: ( ->
    ['inbox', 'sent', 'drafts', 'scheduled'].contains @get('folder')
  ).property('folder')

  radiumIsActive: Ember.computed.equal('folder', 'radium')
  searchIsActive: Ember.computed.equal('folder', 'search')

  actions:
    checkMessageItem: ->
      currentPath = @get('currentPath')
      if @get('content.content').filterProperty('isChecked').get('length')
        return if currentPath == 'messages.bulk_actions'
        @transitionToRoute 'messages.bulk_actions'
      else if currentPath == 'messages.bulk_actions'
        if email = @get('controllers.emailsShow.model')
          @send 'selectItem', email
        else if discussion = @get('controllers.messagesDiscussion')
          @send 'selectItem', discussion

    loadInitialPages: ->
      return if @get('searchIsActive')
      return if @get('page') > 1 && @get('currentUser.initialMailImported')

      meta = @get('store').typeMapFor(Radium.Email).metadata

      Ember.run.next =>
        @set('totalRecords', meta.totalRecords)
        @set('allPagesLoaded', meta.allPagesLoaded)

      pageSize = @get('controllers.messages.pageSize')

      if meta.totalRecords > pageSize
        for i in [0...3]
          currentCount = (i + 1) * pageSize
          @send 'showMore' if meta.totalRecords >= currentCount

    reset: ->
      @set('page', 1)
      @set('allPagesLoaded', false)
      @set('isLoading', false)

    toggleSearch: ->
      @toggleProperty 'isSearchOpen' 

  modelQuery: ->
    queryParams = Ember.merge(@get('controllers.messages').queryParams(), page: @get('page'))

    Radium.Email.find(queryParams)

  isSearchOpen: false
