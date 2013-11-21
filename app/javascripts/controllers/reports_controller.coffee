###
Note: This controller is WIP. Filtering and Crossfilter setup
needs to be significantly trimmed, there is an exorbitant amount of filter lookups
that need to be reduced elegantly
###
Radium.ReportsController = Ember.ArrayController.extend
  needs: ['account']
  account: Ember.computed.alias 'controllers.account'
  leadsDomain: [new Date(2013, 1, 1), new Date(2013, 11, 31)]
  startDate: Ember.DateTime.create(),
  endDate: Ember.DateTime.create(),

  defaultSelectedUser: 'Everyone'
  selectedUser: Ember.computed.defaultTo('defaultSelectedUser')
  defaultSelectedQuarter: 'All Quarters'
  selectedQuarter: Ember.computed.defaultTo('defaultSelectedQuarter')
  defaultSelectedCompany: 'All Companies'
  selectedCompany: Ember.computed.defaultTo('defaultSelectedCompany')

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
        p.total = p.total + 1
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
        p.total = p.total - 1
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
        total: 0
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
    deals = @get 'dealsGroup'
    users = @get 'usersGroup'
    quarters = @get 'quartersGroup'
    companies = @get 'companiesGroup'
    allTotals = totalsByStatus.all()
    allStatuses = statusesByAmount.all()
    allDeals = deals.all()

    @set 'users', users.all()
    @set 'quarters', quarters.all()
    @set 'companies', companies.all()

    allTotals.forEach((item) =>
      @set 'total_' + item.key, item.value
    )

    allStatuses.forEach((item) =>
      @set 'status_' + item.key + '_total', item.value
    )

    allDeals.forEach((item) =>
      @set 'deal_' + item.key, item.value
    )

  setDates: (start, end) ->
    unless arguments.length
      date = new Date()
      start = d3.time.year.floor(date)
      end = d3.time.year.ceil(date)

    @setProperties(
      startDate: Ember.DateTime.create(start.getTime())
      endDate: Ember.DateTime.create(end.getTime())
    )

  actions:
    filterByDate: (date) ->
      if date
        @get('quarterDimension').filter(null)
        @set 'selectedQuarter', null
        @get('dealDimension').filter(date)
        @setDates(date[0], date[1])
        @calcSums()
      else
        @setDates()
      dc.redrawAll()

    reset: ->
      @get('userDimension').filter(null)
      @get('dealDimension').filter(null)
      @get('quarterDimension').filter(null)
      @get('statusDimension').filter(null)
      @get('companyDimension').filter(null)
      @set 'selectedUser', null
      @set 'selectedQuarter', null
      @calcSums()
      dc.filterAll()
      dc.redrawAll()

    filterThisMonth: ->
      day = new Date()
      start = d3.time.month.floor(day)
      end = d3.time.month.ceil(day)
      @get('dealDimension').filter([start, end])
      @get('quarterDimension').filter(null)
      @set 'selectedQuarter', null
      @setDates(start, end)
      @calcSums()
      dc.redrawAll()

    filterByUser: (user) ->
      @set 'selectedUser', user
      @get('userDimension').filter(user)
      @calcSums()
      dc.redrawAll()

    filterByCompany: (company) ->
      @get('companyDimension').filter(company)
      @set('selectedCompany', company)
      @calcSums()
      dc.redrawAll()

    filterByQuarter: (quarter) ->
      @get('quarterDimension').filter(quarter)
      @set 'selectedQuarter', quarter
      @calcSums()

      switch quarter
        when "Q1" then @setDates(new Date(2013, 0, 1), new Date(2013, 2, 31))
        when "Q2" then @setDates(new Date(2013, 3, 1), new Date(2013, 5, 30))
        when "Q3" then @setDates(new Date(2013, 6, 1), new Date(2013, 8, 30))
        when "Q4" then @setDates(new Date(2013, 9, 1), new Date(2013, 11, 31))
        else @send('filterByYear', new Date())
      
      dc.redrawAll()

    filterByYear: (year) ->
      date = new Date()
      start = d3.time.year.floor(date)
      end = d3.time.year.ceil(date)
      @get('yearDimension').filter([start, end])
      @setDates(start, end)
      @calcSums()
      dc.redrawAll()