Radium.CalendarRoute = Ember.Route.extend
  serialize: (model) ->
    {
      year: model.get('year')
      month: model.get('month')
      day: model.get('day')
    }

  model: (params) ->
    string = "#{params.year}-#{params.month}-#{params.day}"
    Ember.DateTime.parse string, "%Y-%m-%d"
