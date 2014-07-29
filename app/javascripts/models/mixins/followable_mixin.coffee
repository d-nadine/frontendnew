Radium.FollowableMixin = Ember.Mixin.create
  isPublic: DS.attr('boolean', defaultValue: true)
  contactsFollowed: DS.hasMany('Radium.Contact', inverse: null)
  usersFollowed: DS.hasMany('Radium.User', inverse: null)
