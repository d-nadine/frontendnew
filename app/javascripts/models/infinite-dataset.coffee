Radium.InfiniteDataset = Ember.ArrayProxy.extend
  params: {}

  isLoading: false

  content: Ember.computed 'source', ->
    Ember.A []

  source: Ember.computed 'params', 'store', 'type', ->
    Radium.PagedDataset.create
      params: @get 'params'
      store: @get "store"
      type: @get "type"
      meta: {}

  loadPage: Ember.observer('source.content', ->
    @set 'isLoading', true
    content = @get('content')
    source = @get('source.content')
    queue = @queue || Ember.RSVP.resolve()
    self = this

    @queue = queue.then ->
      source.then (records) ->
        self.set 'isLoading', false
        content.addObjects source
        meta = source.get('store').typeMapFor(source.get('type')).metadata
        source.set 'meta', meta
  ).on 'init'

  expand: ->
    Ember.run.later =>
      @get('source').pageForward()
