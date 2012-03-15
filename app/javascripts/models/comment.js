Radium.Comment = Radium.Core.extend({
  text: DS.attr('string'),
  user: DS.hasOne('Radium.User'),
  reference: DS.attr('number'),
  attachments: DS.hasMany('Radium.Attachment'),
  comments: DS.hasMany('Radium.Comment')
});