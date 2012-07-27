Radium.Announcement = Radium.Core.extend({
  title: DS.attr('string'),
  message: DS.attr('string'),
  user: DS.belongsTo('Radium.User')
});