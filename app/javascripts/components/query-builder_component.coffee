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

      @set('queryRan', true)

      false

    addPotentialQuery: (field) ->
      @get('potentialQueries').addObject field

      false

    removeQuery: (query, index) ->
      @get('actualQueries').removeAt index
      @get('potentialQueries').removeAt index

      return unless @actualQueries.length

      @get('parent').send 'runCustomQuery', @actualQueries

      false

  classNameBindings: [':filter-wrap']

  potentialQueries: Ember.A()
  actualQueries: []

  queryRan: false

  saveAvailable: Ember.computed 'queryRan', ->
    @get('queryRan')
