Radium.Comment = Radium.Core.extend({
  dateToISO8601: function() {
    var date = this.get('createdAt'),
        utc = Date.parse(date);
    return Ember.DateTime.create(utc).toISO8601();
  }.property('createdAt').cacheable(),
  text: DS.attr('string'),
  user: DS.hasOne('Radium.User'),
  attachments: DS.hasMany('Radium.Attachment')
});