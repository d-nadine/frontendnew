Radium.MessagesSidebarController = Radium.ArrayController.extend
  needs: ['messages', 'application', 'emailsShow', 'messagesDiscussion']
  page: 0
  allPagesLoaded: false

  applicationController: Ember.computed.alias 'controllers.application'
  content: Ember.computed.alias 'controllers.messages'
  selectedContent: Ember.computed.alias 'controllers.messages.selectedContent'
  totalRecords: Ember.computed.alias 'controllers.messages.content.totalRecords'
  folder: Ember.computed.alias 'controllers.messages.folder'
  itemController: 'messagesSidebarItem'

  inboxIsActive: ( ->
    ['inbox', 'sent'].contains @get('folder')
  ).property('folder')

  radiumIsActive: Ember.computed.equal('folder', 'radium')
  searchIsActive: Ember.computed.equal('folder', 'search')

  actions:
    checkMessageItem: ->
      currentPath = @get('applicationController.currentPath')
      if @get('content.content').filterProperty('isChecked').get('length')
        return if currentPath == 'messages.bulk_actions'
        @transitionToRoute 'messages.bulk_actions'
      else if currentPath == 'messages.bulk_actions'
        if email = @get('controllers.emailsShow.model')
          @send 'selectItem', email
        else if discussion = @get('controllers.messagesDiscussion')
          @send 'selectItem', discussion

    showMore: ->
      return if @get('allPagesLoaded')

      @set('isLoading', true)

      page = @get('page') + 1

      @set('page', page)

      queryParams = Ember.merge(@get('controllers.messages').queryParams(), page: page)

      Radium.Email.find(queryParams).then (emails) =>
        content = @get('content')

        meta = emails.store.typeMapFor(Radium.Email).metadata
        @set('totalRecords', meta.totalRecords)
        @set('allPagesLoaded', meta.isLastPage)

        unless emails.get('length')
          @set('isLoading', false)
          if page > meta.totalPages
            @set 'allPagesLoaded', true
          return

        ids = content.map (email) -> email.get('id')

        emails.toArray().forEach (email) ->
          content.pushObject(email) unless ids.contains(email.get('id'))
          ids.push email.get('id')

        @set('isLoading', false)

    reset: ->
      @set('page', 0)
      @set('allPagesLoaded', false)
      @set('isLoading', false)

  isSearchOpen: false

  toggleSearch: ->
    @toggleProperty 'isSearchOpen' 
