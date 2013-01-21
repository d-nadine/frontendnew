Radium.PipelineStatusController = Em.ArrayProxy.extend
  status: null
  content: [
    Em.Object.create({label: 'Leads', name: 'leads'})
    Em.Object.create({label: 'Negotiating', name: 'negotiating'})
    Em.Object.create({label: 'Closed', name: 'closed'})
    Em.Object.create({label: 'Lost', name: 'lost'})
  ]
  statusDidChange: ( ->
    @setEach('isCurrent', false)
    current = @find (item) => item.name == @get('status')
    current.set('isCurrent', true)
  ).observes('status')
