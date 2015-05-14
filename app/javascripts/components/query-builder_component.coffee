Radium.QueryBuilderComponent = Ember.Component.extend
  actions:
    addPotentialQuery: (field) ->
      @get('potentialQueries').addObject field

      false

    removeQuery: (query) ->
      @get('potentialQueries').removeObject query

      false

  classNameBindings: [':filter-wrap']

  potentialQueries: Ember.A()

  selectedQueries: Ember.computed 'potentialQueries.[]', 'queries.[]', ->
    @get('potentialQueries')
