Factory.define 'checklist_item', traits: 'timestamps',
  kind: 'todo'
  description: Factory.sequence (i) -> "checklist item  #{i}"
  weight: 25
  sFinished: false
