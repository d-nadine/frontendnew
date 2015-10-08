Radium.Company = Radium.Model.extend Radium.HasTasksMixin,
  Radium.AttachmentsMixin,
  contacts: DS.hasMany('Radium.Contact')
  activities: DS.hasMany('Radium.Activity', inverse: 'companies')
  emailAddresses: DS.hasMany('Radium.EmailAddress')
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  addresses: DS.hasMany('Radium.Address')

  marketCategories: DS.hasMany('Radium.MarketCategory')
  technologies: DS.hasMany('Radium.Technology')
  socialProfiles: DS.hasMany('Radium.SocialProfile')

  deals: DS.hasMany('Radium.Deal')
  lists: DS.hasMany('Radium.List')

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

  lastActivityAt: DS.attr('datetime')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  added: Ember.computed 'createdAt', ->
    @get('createdAt').toFormattedString("%B %d, %Y")

  daysInactive: Ember.computed 'lastActivityAt', ->
    if @get("lastActivityAt")?
      @get('lastActivityAt').readableTimeAgo()


  email: Radium.computed.primaryAccessor 'emailAddresses', 'value', 'primaryEmail'
  phone: Radium.computed.primaryAccessor 'phoneNumbers', 'value', 'primaryPhone'
  city: Radium.computed.primaryAccessor 'addresses', 'city', 'primaryAddress'
  street: Radium.computed.primaryAccessor 'addresses', 'street', 'primaryAddress'
  line2: Radium.computed.primaryAccessor 'addresses', 'line2', 'primaryAddress'
  state: Radium.computed.primaryAccessor 'addresses', 'state', 'primaryAddress'

  zipcode: Radium.computed.primaryAccessor 'addresses', 'zipcode', 'primaryAddress'

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
