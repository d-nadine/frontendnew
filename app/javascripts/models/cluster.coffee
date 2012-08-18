Radium.Cluster = Radium.Core.extend
  # TODO: need to figure out what kind of types should we use here,
  #       and check if we can create dynami HasMany type, which will
  #       base contents on "kind" attr
  recordIds: DS.attr('array')
