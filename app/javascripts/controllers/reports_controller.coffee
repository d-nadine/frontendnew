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
    if !!@get("startDate") and !!@get("endDate")
      start = d3.time.day(@get('startDate'))
      end =  d3.time.day(@get('endDate'))
      [start, end]
  ).property('startDate', 'endDate')
  startDate: null
  endDate: null
  defaultSelectedUser: 'Everyone'
  selectedUser: Ember.computed.defaultTo('defaultSelectedUser')
  defaultSelectedCompany: 'All Companies'
  selectedCompany: Ember.computed.defaultTo('defaultSelectedCompany')

  domainObserver: Ember.observer 'startDate', 'endDate', ->
    @calcSums()
    dc.redrawAll()

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

    totalClosed = workflowObjects.filterBy('name', 'closed')[0].total

    @set('workflowObjects', workflowObjects)
    @set('totalClosed', totalClosed)

  actions:
    linkToPipeline: (state) ->
      if state == 'closed'
        this.transitionToRoute('pipeline.closed')
      else if state == 'lost'
        this.transitionToRoute('pipeline.lost')
      else
        this.transitionToRoute('pipeline.workflow', state)

    reset: ->
      @get('user').filter(null)
      @get('deal').filter(null)
      @get('status').filter(null)
      @get('company').filter(null)
      @set 'selectedUser', null
      @set 'startDate', null
      @set 'endDate', null
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