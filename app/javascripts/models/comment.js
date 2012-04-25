Radium.Comment = Radium.Core.extend({
  text: DS.attr('string'),
  user: DS.hasOne('Radium.User'),
  attachments: DS.hasMany('Radium.Attachment')
});