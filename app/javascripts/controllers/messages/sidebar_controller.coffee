Radium.MessagesSidebarController = Radium.ArrayController.extend
  needs: ['messages']
  page: 0
  allPagesLoaded: false

  content: Ember.computed.alias 'controllers.messages'
  selectedContent: Ember.computed.alias 'controllers.messages.selectedContent'
  totalRecords: Ember.computed.alias 'controllers.messages.content.totalRecords'
  folder: Ember.computed.alias 'controllers.messages.folder'
  itemController: 'messagesSidebarItem'

  inboxIsActive: Ember.computed.equal('folder', 'inbox')
  radiumIsActive: Ember.computed.equal('folder', 'radium')
  searchIsActive: Ember.computed.equal('folder', 'search')

  actions:
    showMore: ->
      return if @get('allPagesLoaded')

      @set('isLoading', true)

      page = @get('page') + 1

      @set('page', page)

      queryParams = Ember.merge(@get('controllers.messages').queryParams(), page: page)

      Radium.Email.find(queryParams).then (emails) =>
        messagesProxy = @get('content')
        unless messagesProxy.get('initialSet')
          messagesProxy.set('initialSet', true)

        return unless emails.get('length')

        ids = messagesProxy.map (email) -> email.get('id')

        emails.toArray().forEach (email) ->
          messagesProxy.pushObject(email) unless ids.contains(email.get('id'))
          ids.push email.get('id')

        meta = emails.store.typeMapFor(Radium.Email).metadata
        @set('totalRecords', meta.totalRecords)
        @set('allPagesLoaded', meta.isLastPage)
        @set('isLoading', false)

    reset: ->
      @set('page', 0)
      @set('allPagesLoaded', false)

  isSearchOpen: false

  toggleSearch: ->
    @toggleProperty 'isSearchOpen' 
