Radium.PromoteExternalContact = Radium.Model.extend
  externalContact: DS.belongsTo('Radium.ExternalContact')
  contact: DS.belongsTo('Radium.Contact')
  status: DS.attr('string')
