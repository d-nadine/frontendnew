require 'factories/checklist'

Factory.define 'settings',
  negotiatingStatuses: [
    'Opportunity',
    'Sent Proposal',
    'Waiting Signature'
  ]

  checklist: -> Factory.create 'checklist'
  leadSources: ->
    Dictionaries.leadSources.set
  companyName: 'Initech Inc'
  companyAvatar: {}
  currentPlan: 2
