Radium.InfiniteDataset = Ember.ArrayProxy.extend({
  content: Ember.computed -> Ember.A []

  source: Ember.computed 'params', 'store', 'type', ->
    Radium.PagedDataset.create
      params: @get "params"
      store: @get "store"
      type: @get "type"
      page: 0

  expand: (->
    console.log 'expand'
    @get('source').pageForward().then (source)=>
      @addObjects source
  ).on "init"
})
