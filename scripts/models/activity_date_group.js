define('models/activity_date_group', function(require) {
  
  var Radium = require('radium');

  Radium.ActivityDateGroup = DS.Model.extend({
    type: DS.attr('string'),
    date: DS.attr('string'),
    todos: DS.hasMany('Radium.Todo')

  });

  return Radium;
});