Factory.define 'pipelineChecklist', traits: 'timestamps',
  kind: 'Call'
  description: 'Had a call with client'
  weight: Math.floor(Math.random() * 100)
  date: 1