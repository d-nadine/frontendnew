define('models/announcement', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Announcement = Radium.Core.extend({
    title: DS.attr('string'),
    message: DS.attr('string'),
    comments: DS.hasMany(Radium.Comment),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User)
  });
  
  return Radium;
});