define('models/comment', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Comment = Radium.Core.extend({
    text: DS.attr('string'),
    user: DS.hasOne('Radium.User'),
    reference: DS.attr('integer'),
    attachments: DS.hasMany('Radium.Attachment') 
  });
  
  return Radium;
});