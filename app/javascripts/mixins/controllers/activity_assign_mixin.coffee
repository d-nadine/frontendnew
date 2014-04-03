Radium.ActivityAssignMixin = Ember.Mixin.create
  oldUser: ( ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.oldUserId') + "")
  ).property('meta.oldUserId')

  newUser: ( ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.newUserId') + "")
  ).property('meta.newUserId')

  email: Ember.computed 'meta.emailId', ->
    emailId = @get('meta.emailId')
    return unless emailId

    Radium.Email.find(emailId).then( (result) =>
      @set 'email', result
    )
