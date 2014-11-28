Radium.BulkActionsJob = Radium.Model.extend
  action: DS.attr('string')
  ids: DS.attr('array')
  user: DS.belongsTo('Radium.User')
  public: DS.attr('boolean')
  newTags: DS.attr('array')