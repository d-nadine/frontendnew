Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  settings: DS.belongsTo('Radium.UserSettings')
  account: DS.belongsTo('Radium.Account')

  deals: DS.hasMany('Radium.Deal')

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')

  activities: DS.hasMany('Radium.Activity', inverse: 'user')

  userStatistics: DS.belongsTo('Radium.UserStatistics')

  firstName: DS.attr('string')
  lastName: DS.attr('string')
  title: DS.attr('string')
  isAdmin: DS.attr('boolean')
  initialMailImported: DS.attr('boolean')
  emailsImported: DS.attr('number')
  refreshFailed: DS.attr('boolean')
  syncState: DS.attr('string')

  contactInfo: DS.belongsTo('Radium.ContactInfo')
  subscriptionInvalid: DS.attr('boolean')

  contactsFollowed: DS.hasMany('Radium.Contact')
  usersFollowed: DS.hasMany('Radium.User')
  following: Radium.computed.aggregate('contactsFollowed', 'usersFollowed')

  email: DS.attr('string')
  phone: DS.attr('string')

  avatarKey: DS.attr('string')

  lastLoggedIn: DS.attr('date')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  salesGoal: DS.attr('number')

  token: DS.attr('string')

  name: Ember.computed 'firstName', 'lastName', ->
    "#{@get("firstName")} #{@get("lastName")}"

  contacts: Ember.computed 'deals.[]', ->
    Radium.Contact.all().filter (contact) =>
      contact.get('user') == this && !contact.get('isPersonal')

  isSyncing: Ember.computed 'syncState', ->
    @get('syncState') != "waiting"

  displayName: Ember.computed.alias 'name'

  clearRelationships: ->
    @get('tasks').compact().forEach (task) =>
      if task.constructor isnt Radium.Meeting
        task.deleteRecord()
      else
        if task.get('organizer') isnt this
          invitation = task.get('invitations').find (invitation) => invitation.get('person') == this
          invitation.unloadRecord()
        else
          task.deleteRecord()

    @get('activities').compact().forEach (activity) ->
      activity.deleteRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceUser') == this
        notification.deleteRecord()
