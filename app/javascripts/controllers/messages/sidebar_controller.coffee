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
