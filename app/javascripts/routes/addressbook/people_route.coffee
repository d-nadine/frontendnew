Radium.PeopleIndexRoute = Radium.Route.extend
  beforeModel: (transition) ->
    filter = transition.params['people.index'].filter

  model: ->
    p "in model"