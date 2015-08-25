Radium.AutocompleteItem = Radium.Model.extend
  name: DS.attr('string')
  email: DS.attr('string')
  source: DS.attr('string')
  avatarKey: DS.attr('string')
  type: DS.attr('string')
  displayName: DS.attr('string')
  count: DS.attr('number')

  person: Ember.computed '_personUser', '_personContact', '_personCompany', (key, value) ->
    if arguments.length == 2 && value
      associationName = value.constructor.toString().humanize()
      @set associationName, value
    else
      @get('_personContact') || @get('_personUser') || @get('_personCompany')

  _personContact: DS.belongsTo('Radium.Contact')
  _personUser: DS.belongsTo('Radium.User')
  _personCompany: DS.belongsTo('Radium.Company')

  resourceList: DS.belongsTo('Radium.List')

  key: Ember.computed 'email', 'type', ->
    type: @get('type')
    email: @get('email')
    key: "#{@get('email')} - #{@get('type')}"

  isExternal: Ember.computed 'person', ->
    Ember.isEmpty(@get('person'))

  isList: Ember.computed 'type', ->
    @get('type') == 'list'
