Radium.QueryBuilderComponent = Ember.Component.extend
  actions:
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
      @get('actualQueries').removeAt index
      @get('potentialQueries').removeAt index

      @get('parent').send 'runCustomQuery', @actualQueries

      false

  classNameBindings: [':filter-wrap']

  potentialQueries: Ember.A()
  actualQueries: []
