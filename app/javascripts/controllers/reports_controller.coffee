Radium.ReportsController = Ember.ArrayController.extend
  needs: ['account']
  account: Ember.computed.alias 'controllers.account'

  setupCrossfilter: ->
    data = crossfilter(@get('content'))
    all = data.groupAll()
    date = data.dimension (d) -> d.date
    dates = date.group()
    user = data.dimension (d) -> d.user
    users = user.group()

    @setProperties(
      crossfilter: data
      dateDimension: date
      datesGroup: dates
      userDimension: user
      usersGroup: users
    )

  actions:
    filterByUser: (user) ->
      console.log(user)