define('models/comment', function(require) {
  require('ember');
  require('data');
  
  Radium.Comment = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    text: DS.attr('string'),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User),
    attachments: DS.hasMany(Radium.Attachment) 
  });
  
});