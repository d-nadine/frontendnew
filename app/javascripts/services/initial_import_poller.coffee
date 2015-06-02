require "mixins/controllers/poller_mixin"

Radium.InitialImportPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 3000
  isLoading: Ember.computed.alias 'controller.isLoading'
  allPagesLoaded: Ember.computed.alias 'controller.allPagesLoaded'
  page: Ember.computed.alias 'controller.page'

  onPoll: ->
    currentUser = @get('currentUser')
    Ember.assert "You need to pass set currentUser on the InitialImportPoller", currentUser

    return unless user = @get('currentUser.model')

    messagesRoute = currentUser.container.lookup('route:messages')
    peopleRoute = currentUser.container.lookup('route:peopleIndex')
    messagesSidebarController = currentUser.container.lookup('controller:messagesSidebar')
    currentPath = currentUser.container.lookup('controller:application').get('currentPath')

    refresh = ->
      if currentPath == "addressbook.people.index"
        peopleRoute.refresh()
      else if currentPath.indexOf('messages') != -1
        messagesSidebarController.send 'showMore'

    if user.get('initialMailImported')
      @stop()

      Radium.Email.find(page: 1, page_size: 25)
      peopleRoute.refresh()
      messagesRoute.refresh()
      user.reload()

      return

    refresh()

    user.reload()
