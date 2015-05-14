Radium.QueryBuilderComponent = Ember.Component.extend
  actions:
    modifyQuery: (query) ->
      #package up queryparts and send to parent

      queryParts = @actualQueries

      queryParts.push query

      @get('parent').send 'runCustomQuery', queryParts

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
