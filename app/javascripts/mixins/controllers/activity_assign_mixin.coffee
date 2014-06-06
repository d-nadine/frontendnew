Radium.ActivityAssignMixin = Ember.Mixin.create
  oldUser: Ember.computed 'meta.oldUserId', ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.oldUserId') + "")

  newUser: Ember.computed 'meta.newUserId', ->
    Radium.User.all().find (user) => user.get('id') == (@get('meta.newUserId') + "")

  email: Ember.computed 'meta.emailId', ->
    emailId = @get('meta.emailId')
    return unless emailId

    activity = @get('model')
    store = @get('store')

    Radium.Email.find(emailId).then( (result) =>
      @set 'email', result
    ).catch (result) =>
      # pretty hacky but until the email_id is separated
      # from the meta field, then it will do
      return if result.constructor != Radium.Email && !result.get('isError')
      activity.deleteRecord()
      store.commit()
