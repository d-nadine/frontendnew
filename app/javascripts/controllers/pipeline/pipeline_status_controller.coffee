Radium.PipelineStatusController = Em.ArrayProxy.extend
  content: [
    Em.Object.create({label: 'Leads', name: 'leads'})
    Em.Object.create({label: 'Negotiating', name: 'negotiating'})
    Em.Object.create({label: 'Closed', name: 'closed'})
    Em.Object.create({label: 'Lost', name: 'lost'})
  ]
