Radium.PagedDataset = Ember.ArrayProxy.extend
  page: 1
  params: {}
  content: Ember.computed 'params', 'page', ->
    type = @get 'type'
    page = @get 'page'

    Ember.assert 'type must be defined', !!type

    params = Ember.merge {page: page}, @get 'params'
    type.find params

  resetPaging: Ember.observer 'params', ->
    @set 'page', 1

  pageForward: ->
    @set 'page', @get('page') + 1
    @get 'content'

  pageBackward: ->
    @set 'page', @get('page') - 1 unless @get('page') <= 0
    @get 'content'
