Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  settings: DS.belongsTo('Radium.UserSettings')
  account: DS.belongsTo('Radium.Account')

  deals: DS.hasMany('Radium.Deal')

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')

  activities: DS.hasMany('Radium.Activity', inverse: 'user')

  firstName: DS.attr('string')
  lastName: DS.attr('string')
  title: DS.attr('string')
  isAdmin: DS.attr('boolean')
  initialMailImported: DS.attr('boolean')
  emailsImported: DS.attr('number')
  refreshFailed: DS.attr('boolean')
  trialPeriodHasExpired: DS.attr('boolean')
  isPaidAccount: DS.attr('boolean')

  contactInfo: DS.belongsTo('Radium.ContactInfo')

  following: DS.hasMany('Radium.User')

  email: DS.attr('string')
  phone: DS.attr('string')

  avatarKey: DS.attr('string')

  lastLoggedIn: DS.attr('date')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  salesGoal: DS.attr('number')

  token: DS.attr('string')

  name: ( ->
    "#{@get("firstName")} #{@get("lastName")}"
  ).property('firstName', 'lastName')

  contacts: ( ->
    Radium.Contact.all().filter (contact) =>
      contact.get('user') == this && !contact.get('isPersonal')
  ).property('deals.[]')

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

    @get('activities').compact().forEach (activity) =>
      activity.deleteRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceUser') == this
        notification.deleteRecord()
