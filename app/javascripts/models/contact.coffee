Radium.Contact = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,
  Radium.AttachmentsMixin,

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting', inverse: '_referenceContact')
  deals: DS.hasMany('Radium.Deal', inverse: 'contact')
  tags: DS.hasMany('Radium.Tag')
  tagNames: DS.hasMany('Radium.TagName')
  activities: DS.hasMany('Radium.Activity', inverse: 'contacts')
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  emailAddresses: DS.hasMany('Radium.EmailAddress')
  addresses: DS.hasMany('Radium.Address')
  notes: DS.hasMany('Radium.Note', inverse: '_referenceContact')

  user: DS.belongsTo('Radium.User')
  company: DS.belongsTo('Radium.Company', inverse: 'contacts')

  contactInfo: DS.belongsTo('Radium.ContactInfo')

  contactImportJob: DS.belongsTo('Radium.ContactImportJob')

  name: DS.attr('string')
  companyName: DS.attr('string')
  status: DS.attr('string')
  source: DS.attr('string')
  title: DS.attr('string')
  avatarKey: DS.attr('string')
  about: DS.attr('string')
  removeCompany: DS.attr('boolean')
  updateStatus: DS.attr('string')
  lastActivityAt: DS.attr('date')
  activityCount: DS.attr('number')

  daysInactive: Ember.computed 'lastActivityAt', ->
    if @get("lastActivityAt")?
      moment.duration((new Date - @get("lastActivityAt")), "milliseconds").humanize()

  isPublic: DS.attr('boolean')
  isPersonal: Ember.computed.not 'isPublic'

  ignored: DS.attr('boolean')

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: Ember.computed 'deals', ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')

  tasks: Radium.computed.tasks('todos', 'meetings')

  isLead: Ember.computed.equal 'status', 'pipeline'

  isExcluded: Ember.computed 'status', ->
    @get('status') == 'exclude'

  notifications: DS.hasMany('Radium.Notification', inverse: '_referenceContact')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  email: Ember.computed.alias 'primaryEmail.value'

  openDeals: Ember.computed 'deals.[]', ->
    @get('deals').filterProperty 'isOpen'

  displayName: Ember.computed 'name', 'primaryEmail', 'primaryPhone', ->
    @get('name') || @get('primaryEmail.value') || @get('primaryPhone.value')

  nameWithCompany: Ember.computed 'name', 'company.name', ->
    if @get('company.name')
      "#{@get('name')} (#{@get('company.name')})"
    else
      @get('name')

  isUpdating: Ember.computed.equal 'updateStatus', 'updating'

  track: ->
    @set('isPublic', true)
    @set('status', 'pipeline')

  clearRelationships: ->
    @get('deals').compact().forEach (deal) ->
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

    @get('activities').compact().forEach (activity) ->
      activity.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceContact') == this || notification.get('reference.sender') == this || notification.get('email.sender') == this || notification.get('_referenceEmail.sender') == this
        notification.deleteRecord()

    @_super.apply this, arguments
