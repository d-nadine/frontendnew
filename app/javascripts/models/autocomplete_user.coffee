Radium.AutocompleteUser = Radium.Model.extend
  firstName: DS.attr('string')
  lastName: DS.attr('string')
  email: DS.attr('email')
  user: DS.belongsTo('Radium.User')

Radium.AutocompleteCompany.reopenClass
  property: 'user'
