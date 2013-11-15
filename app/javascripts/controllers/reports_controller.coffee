Radium.ReportsController = Ember.ArrayController.extend
  needs: ['account']
  account: Ember.computed.alias 'controllers.account'
  leadsDomain: [new Date(2013, 1, 1), new Date(2013, 11, 31)]

  setupCrossfilter: ->
    today = new Date()
    data = crossfilter(@get('content'))
    all = data.groupAll()

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

    deal = data.dimension((d) -> d.date)
    deals = deal.group(d3.time.month).reduce(
      (p, v) ->
        if v.status is "lead"
          p.leads++
        else if v.status is "lost"
          p.lost++ 
        else if v.status is "closed"
          p.closed++ 
        else 
          p.deals++
        p
      (p, v) ->
        if v.status is "lead"
          p.leads--
        else if v.status is "lost"
          p.lost-- 
        else if v.status is "closed"
          p.closed-- 
        else 
          p.deals--
        p
      () ->
        leads: 0 
        deals: 0
        closed: 0
        lost: 0
    )
    
    # TODO: Break this into a composable object, so it can be
    # iterated over when applying filters
    @setProperties(
      crossfilter: data
      quarterDimension: quarter
      quartersGroup: quarters
      userDimension: user
      usersGroup: users
      dealDimension: deal
      dealsGroup: deals
    )

  actions:
    reset: ->
      @get('userDimension').filter(null)
      @get('quarterDimension').filter(null)
      @get('dealDimension').filter(null)
      dc.redrawAll()

    filterThisMonth: ->
      @get('quarterDimension').filter(null)
      @get('userDimension').filter(null)
      @get('dealDimension').filter([new Date(2013,10,1), new Date(2013,10,31)])
      dc.redrawAll()

    filterByUser: (user) ->
      @get('quarterDimension').filter(null)
      @get('dealDimension').filter(null)
      @get('userDimension').filter(user)
      dc.redrawAll()

    filterByQuarter: (quarter) ->
      @get('userDimension').filter(null)
      @get('dealDimension').filter(null)
      @get('quarterDimension').filter(quarter)
      dc.redrawAll()