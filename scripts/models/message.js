define('models/message', function(require) {
  require('ember');
  require('data');
  
  Radium.Message = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    message: DS.attr('string'),
    sent_at: DS.attr('date'),
    type: DS.attr('string'),
    users: DS.hasMany(Radium.User),
    contacts: DS.hasMany(Radium.Contact),
    comments: DS.hasMany(Radium.Comment),
    attachments: DS.hasMany(Radium.Attachment),
    todos: DS.hasMany(Radium.Todo)
  });
  
});