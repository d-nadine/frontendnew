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

    p currentPath
    refresh = ->
      p "refreshing...."
      if currentPath == "addressbook.people.index"
        p "people refresh"
        peopleRoute.refresh()
      else if currentPath.indexOf('messages') != -1
        p "messages refresh"
        messagesSidebarController.send 'showMore'

      user.reload()

    if user.get('initialMailImported')
      @stop()

      p "finishing....."
      peopleRoute.refresh()
      messagesRoute.refresh()
      return

    refresh()

    user.reload()
