Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  settings: DS.belongsTo('Radium.UserSettings')
  account: DS.belongsTo('Radium.Account')

  deals: DS.hasMany('Radium.Deal', inverse: 'user')

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')

  activities: DS.hasMany('Radium.Activity', inverse: 'user')

  userStatistics: DS.belongsTo('Radium.UserStatistics')

  firstName: DS.attr('string')
  lastName: DS.attr('string')
  title: DS.attr('string')
  isAdmin: DS.attr('boolean')
  initialMailImported: DS.attr('boolean')
  initialContactsImported: DS.attr('boolean')
  contactsImported: DS.attr('number')
  emailsImported: DS.attr('number')
  refreshFailed: DS.attr('boolean')
  syncState: DS.attr('string')
  thirdPartyConnected: DS.attr('boolean')
  shareInbox: DS.attr('boolean')

  contactInfo: DS.belongsTo('Radium.ContactInfo')
  subscriptionInvalid: DS.attr('boolean')

  contactsFollowed: DS.hasMany('Radium.Contact')
  companiesFollowed: DS.hasMany('Radium.Company')
  usersFollowed: DS.hasMany('Radium.User')
  following: Radium.computed.aggregate('companiesFollowed', 'contactsFollowed', 'usersFollowed')

  email: DS.attr('string')
  phone: DS.attr('string')

  avatarKey: DS.attr('string')

  lastLoggedIn: DS.attr('date')

  tasks: Radium.computed.tasks('todos', 'meetings')

  salesGoal: DS.attr('number')

  token: DS.attr('string')

  customQueries: DS.hasMany('Radium.CustomQuery')

  name: Ember.computed 'firstName', 'lastName', ->
    "#{@get("firstName")} #{@get("lastName")}"

  contacts: Ember.computed 'deals.[]', ->
    Radium.Contact.all().filter (contact) =>
      contact.get('user') == this && !contact.get('isPersonal')

  isSyncing: Ember.computed 'syncState', ->
    @get('syncState') != "waiting"

  displayName: Ember.computed.oneWay 'name'

  companyName: Ember.computed.oneWay 'account.name'

  clearRelationships: ->
    @get('tasks').compact().forEach (task) =>
      if task.constructor isnt Radium.Meeting
        task.unloadRecord()
      else
        if task.get('organizer') isnt this
          invitation = task.get('invitations').find (invitation) => invitation.get('person') == this
          invitation.unloadRecord()
        else
          task.unloadRecord()

    @get('activities').compact().forEach (activity) ->
      activity.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceUser') == this
        notification.unloadRecord()
