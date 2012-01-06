define('models/following', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.Following = Radium.Core.extend({
    approved: DS.attr('boolean'),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User),
    // TODO: Look into how to deal with this nested resource
    followable: DS.hasMany(Radium.Contact)
  });
  
});