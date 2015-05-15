Radium.QueryBuilderComponent = Ember.Component.extend
  actions:
    modifyQuery: (query, index) ->
      if current = @actualQueries.objectAt(index)
        existing = @actualQueries.removeAt index
        @actualQueries.insertAt index, query
      else
        @actualQueries.pushObject query

      @get('parent').send 'runCustomQuery', @actualQueries

      false

    addPotentialQuery: (field) ->
      @get('potentialQueries').addObject field

      false

    removeQuery: (query) ->
      @get('actualQueries').removeObject query

      false

  classNameBindings: [':filter-wrap']

  potentialQueries: Ember.A()
  actualQueries: []
