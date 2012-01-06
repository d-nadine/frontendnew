define('models/comment', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.Comment = Radium.Core.extend({
    text: DS.attr('string'),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User),
    attachments: DS.hasMany(Radium.Attachment) 
  });
  
});