Radium.Company = Radium.Model.extend Radium.HasTasksMixin,
  Radium.AttachmentsMixin,
  contacts: DS.hasMany('Radium.Contact')
  activities: DS.hasMany('Radium.Activity', inverse: 'companies')
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  marketCategories: DS.hasMany('Radium.MarketCategory')
  technologies: DS.hasMany('Radium.Technology')
  socialProfiles: DS.hasMany('Radium.SocialProfile')

  deals: DS.hasMany('Radium.Deal')
  lists: DS.hasMany('Radium.List')
  addresses: DS.hasMany('Radium.Address')

  primaryContact: DS.belongsTo('Radium.Contact', inverse: 'company')

  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  website: DS.attr('string')
  about: DS.attr('string')

  avatarKey: DS.attr('string')
  description: DS.attr('string')
  companyType: DS.attr('string')
  employees: DS.attr('string')

  sector: DS.attr('string')
  industry: DS.attr('string')
  industryGroup: DS.attr('string')
  subindustry: DS.attr('string')

  displayName: Ember.computed.alias 'name'

  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')
  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  clearRelationships: ->
    @get('contacts').compact().forEach (contact) ->
      contact.unloadRecord()

    @get('tasks').compact().forEach (task) ->
      task.unloadRecord()

    @get('activities').compact().forEach (activity) ->
      activity.unloadRecord()

  openDeals: DS.attr('number')
