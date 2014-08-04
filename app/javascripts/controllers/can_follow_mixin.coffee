Radium.CanFollowMixin = Ember.Mixin.create
  canFollow: Ember.computed 'model.user', 'currentUser', ->
    @get('model.user') != @get('currentUser')
