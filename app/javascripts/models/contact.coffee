Radium.Contact = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,
  Radium.AttachmentsMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call', inverse: 'contact')
  meetings: DS.hasMany('Radium.Meeting', inverse: '_referenceContact')
  deals: DS.hasMany('Radium.Deal', inverse: 'contact')
  followers: DS.hasMany('Radium.User', inverse: 'contacts')
  tags: DS.hasMany('Radium.Tag')
  tagNames: DS.hasMany('Radium.TagName')
  activities: DS.hasMany('Radium.Activity', inverse: 'contacts')
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  emailAddresses: DS.hasMany('Radium.EmailAddress')
  addresses: DS.hasMany('Radium.Address')

  user: DS.belongsTo('Radium.User')
  company: DS.belongsTo('Radium.Company', inverse: 'contacts')

  contactInfo: DS.belongsTo('Radium.ContactInfo')

  name: DS.attr('string')
  companyName: DS.attr('string')
  status: DS.attr('string')
  source: DS.attr('string')
  status: DS.attr('string')
  title: DS.attr('string')
  avatarKey: DS.attr('string')
  notes: DS.attr('string')
  removeCompany: DS.attr('boolean')

  isPersonal: Ember.computed.equal 'status', 'personal'
  isPublic: Ember.computed.not 'isPersonal'

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  isLead: Ember.computed.equal 'status', 'pipeline'

  isPersonal: ( ->
    @get('status') == 'personal'
  ).property('status')

  isExcluded: ( ->
    @get('status') == 'exclude'
  ).property('status')

  notifications: DS.hasMany('Radium.Notification', inverse: '_referenceContact')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  email: Ember.computed.alias 'primaryEmail.value'

  openDeals: ( ->
    @get('deals').filterProperty 'isOpen'
  ).property('deals.[]')

  displayName: ( ->
    @get('name') || @get('primaryEmail.value') || @get('primaryPhone.value')
  ).property('name', 'primaryEmail', 'primaryPhone')

  nameWithCompany: ( ->
    if @get('company.name')
      "#{@get('name')} (#{@get('company.name')})"
    else
      @get('name')
  ).property('name', 'company.name')

  clearRelationships: ->
    @get('deals').compact().forEach (deal) =>
      deal.unloadRecord()

    @get('tasks').compact().forEach (task) =>
      if task.constructor isnt Radium.Meeting
        task.deleteRecord()
      else
        if task.get('reference') isnt this
          invitation = task.get('invitations').find (invitation) => invitation.get('person') == this
          invitation?.unloadRecord()
        else
          task.deleteRecord()

    @get('activities').compact().forEach (activity) =>
      activity.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceContact') == this || notification.get('reference.sender') == this || notification.get('email.sender') == this || notification.get('_referenceEmail.sender') == this 
        notification.deleteRecord()
