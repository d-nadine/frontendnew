Radium.Announcement = Radium.Core.extend({
  title: DS.attr('string'),
  message: DS.attr('string'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),
  user: DS.hasOne('Radium.User')
});