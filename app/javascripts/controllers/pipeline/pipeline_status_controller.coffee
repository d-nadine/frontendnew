Radium.PipelineStatusController = Em.ArrayController.extend
  itemController: 'pipeline_status_item'
  status: null
  current: null
  content: [
    Em.Object.create({label: 'Leads', name: 'lead'})
    Em.Object.create({label: 'Negotiating', name: 'negotiating'})
    Em.Object.create({label: 'Closed', name: 'closed'})
    Em.Object.create({label: 'Lost', name: 'lost'})
  ]

  deals: Ember.A()
  contacts: Ember.A()

  statusDidChange: ( ->
    @setEach('isCurrent', false)
    current = @find (item) => item.get('name') == @get('status')
    current.set('isCurrent', true)
    @set('current', current)
  ).observes('status')

  leadTotal: ( ->
    @pipelineTotal('lead')
  ).property('contacts', 'contacts.length')

  negotiatingTotal: ( ->
    @pipelineTotal('negotiating')
  ).property('deals', 'deals.length')

  closedTotal: ( ->
    @pipelineTotal('closed')
  ).property('deals', 'deals.length')

  lostTotal: ( ->
    @pipelineTotal('lost')
  ).property('contacts', 'contacts.length')

  pipelineTotal: (status) ->
    list = if status == 'lead' || status == 'lost' then 'contacts' else 'deals'

    @get(list).filterProperty('status', status).get('length')
