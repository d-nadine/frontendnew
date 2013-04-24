Factory.define 'checklist_item', traits: 'timestamps',
  kind: 'todo'
  description: Factory.sequence (i) -> "checklist item  #{i}"
  weight: 25
  sFinished: false

Factory.define 'checklist',
  checklistItems: -> [
    Factory.create 'checklist_item',
      kind: 'call'
      description: 'Had a call with client'
      weight: 10
    Factory.create 'checklist_item',
      kind: 'meeting'
      description: 'Had a meeting with client'
      weight: 30
    Factory.create 'checklist_item',
      kind: 'todo'
      description: 'Send a quote to a client'
      weight: 20
    Factory.create 'checklist_item',
      kind: 'deal'
      description: 'Client signed the deal'
      weight: 40
  ]


