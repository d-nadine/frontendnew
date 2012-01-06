define('models/todo', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.Todo = Radium.Core.extend({
    description: DS.attr('string'),
    finish_by: DS.attr('date'),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User),
    // FIXME: DS.hasOne
    campaign: DS.hasMany(Radium.Campaign),
    todos: DS.hasMany(Radium.Todo),
    pending_todos: DS.hasMany(Radium.Todo),
    finished_todos: DS.hasMany(Radium.Todo),
    overdue_todos: DS.hasMany(Radium.Todo),
    // FIXME: DS.hasOne
    users: DS.hasMany(Radium.User),
    contacts: DS.hasMany(Radium.Contact)
  });
  
});