Factory.define 'campaign', traits: 'timestamps',
  name: Factory.sequence (i) -> "Campaign #{1}"
