Radium.PromoteExternalContact = Radium.Model.extend
  contact: DS.belongsTo('Radium.Contact')
  status: DS.attr('string')
