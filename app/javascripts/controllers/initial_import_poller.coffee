Radium.InitialImportPoller = Ember.Object.extend Radium.PollerMixin,
  interval: 1000
  isLoading: Ember.computed.alias 'controller.isLoading'
  allPagesLoaded: Ember.computed.alias 'controller.allPagesLoaded'
  page: Ember.computed.alias 'controller.page'

  onPoll: ->
    currentUser = @get('currentUser')
    Ember.assert "You need to pass set currentUser on the InitialImportPoller", currentUser

    controller = @get('controller')

    if @get('page') <= 5 && !@get('isLoading') && !@get('allPagesLoaded')
      controller.send 'showMore'

    @get('currentUser').reload() 
    @stop() if @get('currentUser').get('firstObject.initialMailImported')
