Radium.CustomFieldValue = Radium.Model.extend
  contact: DS.belongsTo('Radium.Contact')
  customField: DS.belongsTo('Radium.CustomField')
  value: DS.attr('string')
