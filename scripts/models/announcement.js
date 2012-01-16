define('models/announcement', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Announcement = Radium.Core.extend({
    title: DS.attr('string'),
    message: DS.attr('string'),
    comments: DS.hasMany('Radium.Comment'),
    user: DS.hasOne('Radium.User')
  });
  
  return Radium;
});