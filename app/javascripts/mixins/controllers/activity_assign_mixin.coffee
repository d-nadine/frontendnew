Radium.ActivityAssignMixin = Ember.Mixin.create
  oldUser: ( ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.oldUserId') + "")
  ).property('meta.oldUserId')

  newUser: ( ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.newUserId') + "")
  ).property('meta.newUserId')

  emailIdDidChange: ( ->
    emailId = @get('meta.emailId')
    return unless emailId

    activity = @get('model')
    store = @get('store')
    Radium.Email.find(emailId).then( ((email) => 
        @set('email', email)
      ),
      ((email) =>
        activity.deleteRecord()
        store.commit()
      )
    )
  ).observes('meta.emailId')
