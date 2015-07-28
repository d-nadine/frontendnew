require "mixins/controllers/poller_mixin"

Radium.InitialImportPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 3000

  # UPGRADE: replace with inject
  peopleRoute: Ember.computed ->
    @container.lookup('route:peopleIndex')

  messagesRoute: Ember.computed ->
    @container.lookup('route:messages')

  messagesSidebarController: Ember.computed ->
    @container.lookup('controller:messagesSidebar')

  applicationController: Ember.computed ->
    @container.lookup('controller:application')

  onPoll: ->
    return unless @get('isPolling')
    currentUser = @get('currentUser')
    Ember.assert "You need to pass set currentUser on the InitialImportPoller", currentUser

    return unless user = @get('currentUser')

    messagesRoute = @get('messagesRoute')
    peopleRoute = @get('peopleRoute')
    messagesSidebarController = @get('messagesSidebarController')
    currentPath = @get('applicationController').get('currentPath')

    refresh = ->
      if currentPath.indexOf('people') > -1
        peopleRoute.refresh()
      else if currentPath.indexOf('messages') > -1
        messagesSidebarController.send 'showMore'

    if user.get('initialMailImported') && user.get('initialContactsImported')
      later = Ember.run.later =>
        @stop()

        Ember.run.cancel later
        Radium.Email.find(page: 1, page_size: 25)
        peopleRoute.refresh()
        messagesRoute.refresh()
        refresh()
        user.reload()

       , 1000

    Ember.run.next ->
      refresh()

      user.reload()
