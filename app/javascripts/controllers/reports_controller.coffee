Radium.ReportsController = Ember.ArrayController.extend
  needs: ['account']
  account: Ember.computed.alias 'controllers.account'

  setupCrossfilter: ->
    data = crossfilter(@get('content'))
    all = data.groupAll()
    date = data.dimension (d) -> d.date
    dates = date.group()

    quarter = data.dimension (d) ->
      month = d.date.getMonth()
      if (month <= 2)
        q = "Q1"
      else if (month > 3 && month <= 5)
        q = "Q2"
      else if (month > 5 && month <= 8)
        q = "Q3"
      else
        q = "Q4"
      q
    quarters = quarter.group()

    user = data.dimension (d) -> d.user
    users = user.group().reduceSum((d) ->
      d.total
    )
    total = data.dimension (d) -> d.total
    totals = total.group()
    
    @setProperties(
      crossfilter: data
      dateDimension: date
      datesGroup: dates
      quarterDimension: quarter
      quartersGroup: quarters
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

    filterByUser: (user) ->
      @get('quarterDimension').filter(null)
      @get('userDimension').filter(user)
      dc.redrawAll()

    filterByQuarter: (quarter) ->
      @get('userDimension').filter(null)
      @get('quarterDimension').filter(quarter)
      dc.redrawAll()