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
    messagesSidebarController = currentUser.container.lookup('controller:messagesSidebar')

    if user.get('initialMailImported')
      @stop()

      return messagesRoute.refresh()

    if @get('page') <= 2 && !@get('isLoading') && !@get('allPagesLoaded')
      messagesSidebarController.send 'showMore'

    user.reload()
