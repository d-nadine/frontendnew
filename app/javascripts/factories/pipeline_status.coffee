Factory.define 'pipelinestatus', traits: 'timestamps',
  status: Factory.sequence (i) -> "status  #{i}"

