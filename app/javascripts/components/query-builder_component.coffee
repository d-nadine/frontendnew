Radium.QueryBuilderComponent = Ember.Component.extend
  actions:
    addNewCustomQuery: ->
      @get('parent').send 'addNewCustomQuery', @actualQueries

      false

    modifyQuery: (query, index) ->
      if current = @actualQueries.objectAt(index)
        @actualQueries.removeAt index
        @actualQueries.insertAt index, query
      else
        @actualQueries.pushObject query

      @get('parent').send 'runCustomQuery', @actualQueries

      false

    addPotentialQuery: (field) ->
      @get('potentialQueries').addObject field

      false

    removeQuery: (query, index) ->
      actualQueries = @get('actualQueries')
      potentialQueries = @get('potentialQueries')
      actualQueries.removeAt(index) if actualQueries.objectAt(index)
      potentialQueries.removeAt(index) if potentialQueries.objectAt(index)

      @get('parent').send 'runCustomQuery', @actualQueries, !!!@actualQueries.length

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @EventBus.subscribe "clearQuery", this, "onClearQuery"
    @EventBus.subscribe "showQuery", this, "onShowQuery"

    if @get('actualQueries.length')
      @$().css 'display', 'inline-block'

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    @EventBus.unsubscribe "clearQuery"
    @EventBus.unsubscribe "showQuery"

    @$().css 'display', 'none'

  classNameBindings: [':filter-wrap']

  saveAvailable: Ember.computed 'actualQueries.[]', ->
    !!@get('actualQueries').length

  onClearQuery: ->
    return unless el = @$()

    el.css 'display', 'none'

  onShowQuery: ->
    return unless el = @$()

    el.css 'display', 'inline-block'
