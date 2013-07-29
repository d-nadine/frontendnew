Radium.AutocompleteContact = Radium.Model.extend
  name: DS.attr('string')
  title: DS.attr('string')
  companyName: DS.attr('string')
  source: DS.attr('string')
  contact: DS.belongsTo('Radium.Contact')

Radium.AutocompleteContact.reopenClass
  property: 'contact'
