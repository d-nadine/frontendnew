Radium.AutocompleteItem = Radium.Model.extend
  name: DS.attr('string')
  email: DS.attr('string')
  source: DS.attr('string')

  person: ((key, value) ->
    if arguments.length == 2 && value
      associationName = value.constructor.toString().humanize()
      @set associationName, value
    else
      @get('_personContact') || @get('_personUser') || @get('_personCompany')
  ).property('_personUser', '_personContact', '_personCompany')
  _personContact: DS.belongsTo('Radium.Contact')
  _personUser: DS.belongsTo('Radium.User')
  _personCompany: DS.belongsTo('Radium.Company')

  isExternal: ( ->
    Ember.isEmpty(@get('person'))
  ).property('person')
