require 'factories/checklist'

Factory.define 'settings',
  negotiatingStatuses: [
    'Opportunity',
    'Sent Proposal',
    'Waiting Signature'
  ]

  dealSources: [
    'Lead Form'
    'Website'
    'In Person'
    'Tradeshow'
    'Cold Call'
  ]
  checklist: -> Factory.create 'checklist'
  leadSources: ->
    Dictionaries.leadSources.set
