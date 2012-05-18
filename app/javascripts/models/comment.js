Radium.Comment = Radium.Core.extend({
  dateToISO8601: function() {
    return this.get('createdAt').toISO8601();
  }.property('createdAt').cacheable(),
  text: DS.attr('string'),
  user: DS.hasOne('Radium.User'),
  attachments: DS.hasMany('Radium.Attachment')
});