Radium.CurrentUserMixin = Ember.Mixin.create
  needs: ['currentUser']
  currentUser: Ember.computed.alias('controllers.currentUser.content')
