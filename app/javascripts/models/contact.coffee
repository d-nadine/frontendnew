Radium.Contact = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')
  deals: DS.hasMany('Radium.Deal')
  followers: DS.hasMany('Radium.User', inverse: 'contacts')
  tags: DS.hasMany('Radium.Tag')
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
  about: DS.attr('string')

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  isLead: ( ->
    @get('status') == 'lead'
  ).property('status')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  nameWithCompany: ( ->
    if @get('company.name')
      "#{@get('name')} (#{@get('company.name')})"
    else
      @get('name')
  ).property('name', 'company.name')
