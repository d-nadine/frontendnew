Radium.CurrentUserMixin = Ember.Mixin.create
  needs: ['currentUser']

  currentUser: (->
    @get('controllers.currentUser.content')
  ).property('controllers.currentUser.content')
