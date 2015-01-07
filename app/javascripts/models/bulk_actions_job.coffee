Radium.BulkActionsJob = Radium.Model.extend Radium.BulkActionProperties,
  action: DS.attr('string')
  assignedTo: DS.belongsTo('Radium.User')
  contactStatus: DS.belongsTo('Radium.ContactStatus')
