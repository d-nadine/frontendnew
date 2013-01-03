Factory.define 'group', traits: 'timestamps',
  name: Factory.sequence (i) -> "Group #{i}"
