Radium.CallList = Radium.Core.extend({
  description: DS.attr('string'),
  finishBy: DS.attr('date', {
    key: 'finish_by'
  }),
  user: DS.hasOne('Radium.User'),
  campaign: DS.hasMany('Radium.Campaign'),
  todos: DS.hasMany('Radium.Todo'),
  pendingTodos: DS.hasMany('Radium.Todo', {
    key: 'pending_todos'
  }),
  finishedTodos: DS.hasMany('Radium.Todo', {
    key: 'finished_todos'
  }),
  overdueTodos: DS.hasMany('Radium.Todo', {
    key: 'finished_todos'
  }),
  users: DS.hasMany('Radium.User'),
  contacts: DS.hasMany('Radium.Contact')
});