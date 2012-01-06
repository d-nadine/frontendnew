define('models/announcement', function(require) {
  require('ember');
  require('data');
  
  Radium.Announcement = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    title: DS.attr('string'),
    message: DS.attr('string'),
    comments: DS.hasMany(Radium.Comment),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User)
  });
  
});