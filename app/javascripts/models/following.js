Radium.Following = Radium.Core.extend({
  approved: DS.attr('boolean'),
  user: DS.hasOne('Radium.User'),
  // TODO: Look into how to deal with this nested resource
  followable: DS.hasMany('Radium.Contact')
});