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
    total = data.dimension (d) -> d.total
    totals = total.group()

    @setProperties(
      crossfilter: data
      dateDimension: date
      datesGroup: dates
      userDimension: user
      usersGroup: users
      totalDimension: total
      totalsGroup: totals
    )

  actions:
    reset: ->
      @get('userDimension').filter()
      @get('dateDimension').filter()
      dc.redrawAll()

    filterByQuarter: (quarter) ->
      dates = [new Date(2013, 5, 1), new Date(2013, 8, 30)]
      @get('userDimension').filter(dates)
      @get('dateDimension').filter(null)
      dc.redrawAll()