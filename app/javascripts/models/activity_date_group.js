Radium.ActivityDateGroup = DS.Model.extend({
  type: DS.attr('string'),
  date: DS.attr('string'),
  todos: DS.hasMany('Radium.Todo')

});