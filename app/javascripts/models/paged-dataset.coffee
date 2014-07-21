Radium.PagedDataset = Ember.ArrayProxy.extend({
  page: 1
  params: {}
  content: Ember.computed('params', 'page', ->
    type = @get 'type'
    page = @get 'page'
    store = @get 'store'

    Ember.assert 'type must be defined', !!type
    Ember.assert 'store must be defined', !!store

    params = Ember.merge {page: page}, @get 'params'
    query = type.find params
    console.log 'new page', Ember.guidFor(query), 'page', @get('page'), 'params', @get('params')
    return query
  )

  resetPaging: Ember.observer 'params', ->
    console.log 'reset paging', Ember.guidFor(this)
    @set 'page', 1

  pageForward: ->
    @set 'page', @get('page') + 1
    @get 'content'

  pageBackward: ->
    @set 'page', @get('page') - 1 unless @get('page') <= 0
    @get 'content'
})
