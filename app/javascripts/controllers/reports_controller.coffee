###
Note: This controller is WIP. Filtering and Crossfilter setup
needs to be significantly trimmed, there is an exorbitant amount of filter lookups
that need to be reduced elegantly
###
Radium.ReportsController = Ember.ArrayController.extend
  needs: ['application', 'account']
  account: Ember.computed.alias 'controllers.account'
  app: Ember.computed.alias 'controllers.application'
  domain: (->
    date = new Date(@get('currentYear'), '05', '15')
    [d3.time.year.floor(date), d3.time.year.ceil(date)]
  ).property()
  startDate: Ember.DateTime.create(),
  endDate: Ember.DateTime.create(),
  defaultSelectedUser: 'Everyone'
  selectedUser: Ember.computed.defaultTo('defaultSelectedUser')
  defaultSelectedCompany: 'All Companies'
  selectedCompany: Ember.computed.defaultTo('defaultSelectedCompany')

  currentYear: 2014

  setupCrossfilter: ->
    today = @get('app.today').toJSDate()
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
          p.leads_total = p.leads_total + v.total
        else if v.status is "lost"
          p.lost++ 
        else if v.status is "closed"
          p.closed++ 
        else 
          p.deals++
          p.deals_total = p.deals_total + v.total
        p
      (p, v) ->
        p.total = p.total - 1
        if v.status is "lead"
          p.leads--
          p.leads_total = p.leads_total - v.total
        else if v.status is "lost"
          p.lost-- 
        else if v.status is "closed"
          p.closed-- 
        else 
          p.deals_total = p.deals_total - v.total
          p.deals--
        p
      () ->
        total: 0
        leads: 0
        leads_total: 0
        deals: 0
        deals_total: 0
        closed: 0
        closed_total: 0
        lost: 0
        lost_total: 0
    )

    company = data.dimension((d) -> d.company)
    companies = company.group()
    
    # TODO: Break this into a composable object, so it can be
    # iterated over when applying filters
    @setProperties(
      crossfilter: data
      year: year
      years: years
      quarter: quarter
      quarters: quarters
      user: user
      users: users
      deal: deal
      deals: deals
      company: company
      companies: companies
      status: status
      statusesByTotal: statusesByTotal
      statusesByAmount: statusesByAmount
    )

    @calcSums()

  calcSums: ->
    totalsByStatus = @get 'statusesByTotal'
    statusesByAmount = @get 'statusesByAmount'
    deals = @get 'deals'
    users = @get 'users'
    quarters = @get 'quarters'
    companies = @get 'companies'
    allTotals = totalsByStatus.all()
    allStatuses = statusesByAmount.all()
    allDeals = deals.all()

    @set 'allUsers', users.all()
    @set 'allQuarters', quarters.all()
    @set 'allCompanies', companies.all()

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
    if arguments.length
      startDate = d3.time.month.floor(start)
      endDate = d3.time.month.ceil(end)
    else
      date = new Date()
      startDate = d3.time.year.floor(date)
      endDate = d3.time.year.ceil(date)

    @setProperties(
      startDate: Ember.DateTime.create(startDate.getTime())
      endDate: Ember.DateTime.create(endDate.getTime())
    )

  actions:
    filterByDate: (date) ->
      if date
        @get('quarter').filter(null)
        @get('deal').filter(date)
        @setDates(date[0], date[1])
        @calcSums()
      else
        @setDates()
      dc.redrawAll()

    reset: ->
      @get('user').filter(null)
      @get('deal').filter(null)
      @get('quarter').filter(null)
      @get('status').filter(null)
      @get('company').filter(null)
      @set 'selectedUser', null
      @calcSums()
      dc.filterAll()
      dc.redrawAll()

    filterThisMonth: ->
      day = @get('app.today').toJSDate()
      start = d3.time.month.floor(day)
      end = d3.time.month.ceil(day)
      @get('deal').filter([start, end])
      @get('quarter').filter(null)
      @setDates(start, end)
      @calcSums()
      dc.redrawAll()

    filterByUser: (user) ->
      @set 'selectedUser', user
      @get('user').filter(user)
      @calcSums()
      dc.redrawAll()

    filterByCompany: (company) ->
      @get('company').filter(company)
      @set('selectedCompany', company)
      @calcSums()
      dc.redrawAll()

    filterByQuarter: (quarter) ->
      @get('quarter').filter(quarter)
      @get('deal').filter()

      year = @get('currentYear')
      switch quarter
        when "Q1" then @setDates(new Date(year, 0, 1), new Date(year, 2, 31))
        when "Q2" then @setDates(new Date(year, 3, 1), new Date(year, 5, 30))
        when "Q3" then @setDates(new Date(year, 6, 1), new Date(year, 8, 30))
        when "Q4" then @setDates(new Date(year, 9, 1), new Date(year, 11, 31))
        else @send('filterByYear')
      
      @calcSums()
      dc.redrawAll()

    filterByYear: ->
      date = new Date()
      start = d3.time.year.floor(date)
      end = d3.time.year.ceil(date)
      @get('year').filter([start, end])
      @setDates(start, end)
      @calcSums()
      dc.redrawAll()