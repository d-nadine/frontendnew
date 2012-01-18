define('models/calllist', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Todo = Radium.Core.extend({
    description: DS.attr('string'),
    finish_by: DS.attr('date'),
    user: DS.hasOne('Radium.User'),
    campaign: DS.hasMany('Radium.Campaign'),
    todos: DS.hasMany('Radium.Todo'),
    pending_todos: DS.hasMany('Radium.Todo'),
    finished_todos: DS.hasMany('Radium.Todo'),
    overdue_todos: DS.hasMany('Radium.Todo'),
    users: DS.hasMany('Radium.User'),
    contacts: DS.hasMany('Radium.Contact')
  });
  
  return Radium;
});