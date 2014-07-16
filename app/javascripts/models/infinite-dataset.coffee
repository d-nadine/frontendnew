Radium.InfiniteDataset = Ember.ArrayProxy.extend({
  paramsBinding: 'source.params'
  content: Ember.computed 'params', 'store', 'type', -> Ember.A []

  source: Ember.computed 'params', 'store', 'type', ->
    Radium.PagedDataset.create
      params: @get 'params'
      store: @get "store"
      type: @get "type"

  loadPage: Ember.observer('source.page', ->
    @get('source.content').then (source)=>
      @addObjects source
  ).on 'init'

  expand: (->
    @get('source').pageForward()
  )
})
