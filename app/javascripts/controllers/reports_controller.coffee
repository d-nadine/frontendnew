###
Note: This controller is WIP. Filtering and Crossfilter setup
needs to be significantly trimmed, there is an exorbitant amount of filter lookups
that need to be reduced elegantly
###

reduceByStatus = (crossfilterGroups, context) ->
  crossfilterGroups.reduce(
    (p, v) ->
      p.total = p.total + 1
      p[v.status]++
      p[v.status + '_total'] = p[v.status + '_total'] + v.total
      p
    (p, v) ->
      p.total = p.total - 1
      p[v.status]--
      p[v.status + '_total'] = p[v.status + '_total'] - v.total
      p
    () ->
      stuff = {}
      context.get('dealStates').forEach (workflow) ->
        workflow = workflow.toLowerCase()
        stuff[workflow] = 0
        stuff[workflow + '_total'] = 0
      stuff['total'] = 0
      stuff
  )

Radium.ReportsController = Ember.ArrayController.extend
  needs: ['application', 'account', 'accountSettings']
  dealStates: Ember.computed.alias 'controllers.accountSettings.dealStates'
  
  account: Ember.computed.alias 'controllers.account'
  app: Ember.computed.alias 'controllers.application'
  domain: (->
    start = d3.time.day(@get('startDate').toJSDate())
    end =  d3.time.day(@get('endDate').toJSDate())
    console.log('domain', start, end)
    [start, end]
  ).property('startDate', 'endDate')
  startDate: Ember.DateTime.create(),
  endDate: Ember.DateTime.create(),
  defaultSelectedUser: 'Everyone'
  selectedUser: Ember.computed.defaultTo('defaultSelectedUser')
  defaultSelectedCompany: 'All Companies'
  selectedCompany: Ember.computed.defaultTo('defaultSelectedCompany')

  currentYear: 2013

  setupCrossfilter: ->
    today = @get('app.today').toJSDate()
    data = crossfilter(@get('content'))
    all = data.groupAll()

    user = data.dimension (d) -> d.user
    users = user.group()
    reduceByStatus(users, this)

    status = data.dimension((d) -> d.status)

    company = data.dimension((d) -> d.company)
    companies = company.group().reduceSum((d) -> d.total)
    reduceByStatus(companies, this)
    # TODO: Break this into a composable object, so it can be
    # iterated over when applying filters
    @setProperties(
      data: data
      crossfilter: data
      user: user
      users: users
      company: company
      companies: companies
      status: status
    )

    @calcSums()

  dateDimension: Ember.computed 'crossfilter', ->
    @get('crossfilter').dimension( (d) -> d.date)

  calcSums: ->
    statusesByTotal = @get('status').group().reduceSum((d) -> d.total)
    statusesByAmount = @get('status').group().reduceCount()

    @set('statusesByTotal', statusesByTotal)
    @set('statusesByAmount', statusesByAmount)

    deal = @get('dateDimension').filter(@get('domain'))
    deals = deal.group()
    reduceByStatus(deals, this)
    @set('deal', deal)
    @set('deals', deals)

    users = @get 'users'
    companies = @get 'companies'
    allTotals = statusesByTotal.all()
    allStatuses = statusesByAmount.all()
    allDeals = deals.all()

    @set 'allUsers', users.all()
    @set 'allCompanies', companies.all()

    totals = {}
    allTotals.forEach (item) =>
      totals[item.key] = item.value

    status_totals = {}
    allStatuses.forEach (item) =>
      status_totals[item.key] = item.value

    deals = {}
    allDeals.forEach (item) =>
      deals[item.key] = item.value

    workflowObjects = []
    @get('dealStates').forEach (rawState) ->
      state = rawState.toLowerCase()
      icon = switch state
        when 'lost' then 'ss-deletefile'
        when 'closed' then 'ss-bill'
        when 'negotiating' then 'ss-briefcase'
        else 'ss-user'

      workflowObjects.push {
        name: rawState
        lowercaseName: state
        total: totals[state]
        status: status_totals[state]
        deal: deals[state]
        icon: icon
      }

    @set('workflowObjects', workflowObjects)

  setDates: (start, end) ->
    @setProperties(
      startDate: Ember.DateTime.create(start.getTime())
      endDate: Ember.DateTime.create(end.getTime())
    )

  actions:
    linkToPipeline: (state) ->
      if state == 'closed'
        this.transitionToRoute('pipeline.closed')
      else if state == 'lost'
        this.transitionToRoute('pipeline.lost')
      else
        this.transitionToRoute('pipeline.workflow', state)

    filterByDate: (startDate, endDate) ->
      console.log('filterByDate', startDate, endDate)
      @setDates(startDate, endDate)
      @calcSums()
      dc.redrawAll()

    reset: ->
      @get('user').filter(null)
      @get('deal').filter(null)
      @get('status').filter(null)
      @get('company').filter(null)
      @set 'selectedUser', null
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