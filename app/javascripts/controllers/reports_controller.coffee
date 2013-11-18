###
Note: This controller is WIP. Filtering and Crossfilter setup
needs to be significantly trimmed, there is an exorbitant amount of filter lookups
that need to be reduced elegantly
###
Radium.ReportsController = Ember.ArrayController.extend
  needs: ['account']
  account: Ember.computed.alias 'controllers.account'
  leadsDomain: [new Date(2013, 1, 1), new Date(2013, 11, 31)]

  setupCrossfilter: ->
    today = new Date()
    data = crossfilter(@get('content'))
    all = data.groupAll()

    year = data.dimension((d) -> d.date)
    years = year.group(d3.time.year)

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

    status = data.dimension((d) -> d.status)
    statusesByTotal = status.group().reduceSum((d) -> d.total)
    statusesByAmount = status.group().reduceCount()

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

    company = data.dimension((d) -> d.company)
    companies = company.group()
    
    # TODO: Break this into a composable object, so it can be
    # iterated over when applying filters
    @setProperties(
      crossfilter: data
      yearDimension: year
      yearsGroup: years
      quarterDimension: quarter
      quartersGroup: quarters
      userDimension: user
      usersGroup: users
      dealDimension: deal
      dealsGroup: deals
      companyDimension: company
      companiesGroup: companies
      statusDimension: status
      statusesByTotal: statusesByTotal
      statusesByAmount: statusesByAmount
    )

    @calcSums()

  calcSums: ->
    totalsByStatus = @get 'statusesByTotal'
    statusesByAmount = @get 'statusesByAmount'
    allTotals = totalsByStatus.all()
    allStatuses = statusesByAmount.all()

    allTotals.forEach((item) =>
      @set 'total_' + item.key, item.value
    )

    allStatuses.forEach((item) =>
      @set 'status_' + item.key + '_total', item.value
    )

  actions:
    filterByDate: (date) ->
      @calcSums()

    chartFilterByUser: (user) ->
      @calcSums()

    reset: ->
      @get('userDimension').filter(null)
      @get('quarterDimension').filter(null)
      @get('dealDimension').filter(null)
      @get('statusDimension').filter(null)
      @get('companyDimension').filter(null)
      @calcSums()
      dc.redrawAll()

    filterThisMonth: ->
      day = new Date()
      start = d3.time.month.floor(day)
      end = d3.time.month.ceil(day)
      @get('dealDimension').filter([start, end])
      @calcSums()
      dc.redrawAll()

    filterByUser: (user) ->
      @get('userDimension').filter(user)
      @calcSums()
      dc.redrawAll()

    filterByCompany: (company) ->
      @get('companyDimension').filter(company)
      @calcSums()
      dc.redrawAll()

    filterByQuarter: (quarter) ->
      @get('quarterDimension').filter(quarter)
      @calcSums()
      dc.redrawAll()

    filterByYear: (year) ->
      date = new Date()
      start = d3.time.year.floor(date)
      end = d3.time.year.ceil(date)
      @get('yearDimension').filter([start, end])
      @calcSums()
      dc.redrawAll()