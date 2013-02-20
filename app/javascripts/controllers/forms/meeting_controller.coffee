Radium.FormsMeetingController = Radium.FormsBaseController.extend
  calendarsOpen: false
  init: ->
    @_super.apply this, arguments
    @set 'users', Radium.MeetingUsers.create()
    @set 'users.startsAt', @get('startsAt')
    @set 'users.endsAt', @get('endsAt')

  startsAtDidChange: ( ->
    @set('users.startsAt', @get('startsAt')) if @get('startsAt')
  ).observes('startsAt')

  showCalendars: ->
    @toggleProperty 'calendarsOpen'
    false

  addUserToMeeting: (userId) ->
    users = @get('users')

    return if users.find( (user) -> user.get('id') == userId )

    user = Radium.User.find(userId)

    users.pushObject user

  removeUserFromMeeting: (userId) ->
    users = @get('users')

    user =  users.find( (user) -> user.get('id') == userId )

    return unless user

    users.removeObject user

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
