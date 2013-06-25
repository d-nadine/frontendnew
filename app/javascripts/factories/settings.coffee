require 'factories/checklist'
# require 'factories/notification_settings'

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
  customFields: [
    key: "test"
  ]

  reminders: -> Factory.create 'notificationSettings'