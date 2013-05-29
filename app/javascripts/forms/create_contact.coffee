Radium.CreateContact = Radium.Model.extend
  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  companyName: DS.attr('string')
  status: DS.attr('string')
  source: DS.attr('string')
  status: DS.attr('string')

  phoneNumbers: DS.attr('array')
  emailAddresses: DS.attr('array')
  addresses: DS.attr('array')
  tagNames: DS.attr('array', defaultValue: [])

Radium.CreateContact.toString = ->
  "Contact"
