Radium.AutocompleteItem = Radium.Model.extend
  name: DS.attr('string')
  email: DS.attr('string')
  source: DS.attr('string')
  avatarKey: DS.attr('string')
  type: DS.attr('string')

  person: ((key, value) ->
    if arguments.length == 2 && value
      associationName = value.constructor.toString().humanize()
      @set associationName, value
    else
      @get('_personContact') || @get('_personUser') || @get('_personCompany') || @get('_personExternalContact')
  ).property('_personUser', '_personContact', '_personCompany')
  _personContact: DS.belongsTo('Radium.Contact')
  _personUser: DS.belongsTo('Radium.User')
  _personCompany: DS.belongsTo('Radium.Company')
  _personExternalContact: DS.belongsTo('Radium.ExternalContact')


  key: ( ->
    type: @get('type')
    email: @get('email')
    key: "#{@get('email')} - #{@get('type')}"
  ).property('email', 'type')

  isExternal: ( ->
    Ember.isEmpty(@get('person'))
  ).property('person')

  displayName: ( ->
    @get('name') || @get('email')
  ).property('name', 'email')
