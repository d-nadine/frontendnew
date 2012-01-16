define('models/following', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Following = Radium.Core.extend({
    approved: DS.attr('boolean'),
    user: DS.hasOne('Radium.User'),
    // TODO: Look into how to deal with this nested resource
    followable: DS.hasMany('Radium.Contact')
  });
  
  return Radium;
});