Radium.Contact = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')
  deals: DS.hasMany('Radium.Deal')
  followers: DS.hasMany('Radium.User', inverse: 'contacts')
  tags: DS.hasMany('Radium.Tag')
  tagNames: DS.hasMany('Radium.TagName')
  activities: DS.hasMany('Radium.Activity', inverse: 'contacts')
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  emailAddresses: DS.hasMany('Radium.EmailAddress')
  addresses: DS.hasMany('Radium.Address')

  user: DS.belongsTo('Radium.User')
  company: DS.belongsTo('Radium.Company', inverse: 'contacts')

  name: DS.attr('string')
  companyName: DS.attr('string')
  status: DS.attr('string')
  source: DS.attr('string')
  status: DS.attr('string')
  title: DS.attr('string')
  avatar: DS.attr('object')
  notes: DS.attr('string')

  isPersonal: Ember.computed.equal 'status', 'personal'
  isPublic: Ember.computed.not 'isPersonal'

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  isLead: ( ->
    @get('status') == 'pipeline'
  ).property('status')

  isPersonal: ( ->
    @get('status') == 'personal'
  ).property('status')

  isExcluded: ( ->
    @get('status') == 'exclude'
  ).property('status')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  email: Ember.computed.alias 'primaryEmail.value'

  displayName: ( ->
    @get('name') || @get('primaryEmail') || @get('primaryPhone')
  ).property('name', 'primaryEmail', 'primaryPhone')

  nameWithCompany: ( ->
    if @get('company.name')
      "#{@get('name')} (#{@get('company.name')})"
    else
      @get('name')
  ).property('name', 'company.name')
