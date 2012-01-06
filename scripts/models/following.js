define('models/following', function(require) {
  require('ember');
  require('data');
  
  Radium.Following = DS.Model.extend({
    approved: DS.attr('boolean'),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User),
    // TODO: Look into how to deal with this nested resource
    followable: DS.hasMany(Radium.Contact)
  });
  
});