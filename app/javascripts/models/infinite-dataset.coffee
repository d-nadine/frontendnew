Radium.InfiniteDataset = Ember.ArrayProxy.extend({
  params: {}

  content: Ember.computed 'source', ->
    content = Ember.A []
    console.log 'reset content to', Ember.guidFor content
    return content

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
        console.log 'adding', source.get('length'),'records from ', Ember.guidFor(source), 'to', Ember.guidFor(content), content.get('length')
        console.log 'first', source.get('firstObject.name'), 'last', source.get('lastObject.name')
        content.addObjects source
  ).on 'init'

  expand: (->
    console.log 'expand dataset'
    @get('source').pageForward()
  )
})
