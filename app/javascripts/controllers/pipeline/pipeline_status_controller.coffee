Radium.PipelineStatusController = Em.ArrayProxy.extend
  status: null
  statuses: [
    Em.Object.create({label: 'Leads', name: 'leads'})
    Em.Object.create({label: 'Negotiating', name: 'negotiating'})
    Em.Object.create({label: 'Closed', name: 'closed'})
    Em.Object.create({label: 'Lost', name: 'lost'})
  ]
  content: Ember.A()
  statusDidChange: ( ->
    @get('statuses').setEach('isCurrent', false)
    current = @get('statuses').find (item) => item.name == @get('status')
    current.set('isCurrent', true)
  ).observes('status')

  leadsTotal: ( ->
    @pipelineTotal('lead')
  ).property('content', 'content.length')

  negotiatingTotal: ( ->
    @pipelineTotal('negotiating')
  ).property('content', 'content.length')

  closedTotal: ( ->
    @pipelineTotal('closed')
  ).property('content', 'content.length')

  lostTotal: ( ->
    @pipelineTotal('lost')
  ).property('content', 'content.length')

  pipelineTotal: (status) ->
    @filterProperty('status', status).get('length')
