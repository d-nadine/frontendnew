Radium.User = Radium.Model.extend Radium.FollowableMixin,
  name: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')

  contacts: DS.hasMany('Radium.Contact')
