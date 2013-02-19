Radium.FormsMeetingController = Radium.FormsBaseController.extend
  calendarsOpen: false
  users: Ember.A()

  showCalendars: ->
    @toggleProperty 'calendarsOpen'
    false

  addUserToMeeting: (userId) ->
    return if @users.find( (user) -> user.get('id') == userId )

    user = Radium.User.find(userId)

    @users.pushObject user

  removeUserFromMeeting: (userId) ->
    user =  @users.find( (user) -> user.get('id') == userId )

    return unless user

    @users.removeObject user
