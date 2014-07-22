Radium.InfiniteDataset = Ember.ArrayProxy.extend
  params: {}

  content: Ember.computed 'source', ->
    Ember.A []

  source: Ember.computed 'params', 'store', 'type', ->
    Radium.PagedDataset.create
      params: @get 'params'
      store: @get "store"
      type: @get "type"

  loadPage: Ember.observer('source.content', ->
    content = @get('content')
    source = @get('source.content')
    queue = @queue || Ember.RSVP.resolve()

    @queue = queue.then ->
      source.then (records)->
        content.addObjects source
  ).on 'init'

  expand: ->
    Ember.run.later =>
      @get('source').pageForward()
