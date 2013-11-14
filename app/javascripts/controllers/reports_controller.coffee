Radium.ReportsController = Ember.ArrayController.extend
  needs: ['account']
  account: Ember.computed.alias 'controllers.account'
  leadsDomain: [new Date(2013, 5, 1), new Date(2013, 10, 31)]

  setupCrossfilter: ->
    today = new Date()
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

    lead = data.dimension((d) -> d.date)
    leads = lead.group()

    user = data.dimension (d) -> d.user
    users = user.group().reduceSum((d) ->
      d.total
    )
    total = data.dimension (d) -> d.total
    totals = total.group()
    
    # TODO: Break this into a composable object, so it can be
    # iterated over when applying filters
    @setProperties(
      crossfilter: data
      dateDimension: date
      datesGroup: dates
      quarterDimension: quarter
      quartersGroup: quarters
      userDimension: user
      usersGroup: users
      leadDimension: lead
      leadsGroup: leads
      totalDimension: total
      totalsGroup: totals
    )

  actions:
    reset: ->
      @get('userDimension').filter()
      @get('dateDimension').filter()
      @get('leadDimension').filter()
      dc.redrawAll()

    filterByUser: (user) ->
      @get('quarterDimension').filter(null)
      @get('leadDimension').filter(null)
      @get('userDimension').filter(user)
      dc.redrawAll()

    filterByQuarter: (quarter) ->
      @get('userDimension').filter(null)
      @get('leadDimension').filter(null)
      @get('quarterDimension').filter(quarter)
      dc.redrawAll()