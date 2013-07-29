Radium.AutocompleteCompany = Radium.Model.extend
  name: DS.attr('string')
  company: DS.belongsTo('Radium.Company')

Radium.AutocompleteCompany.reopenClass
  property: 'company'
