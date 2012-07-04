Radium.CallList = Radium.Core.extend({
  isEditable: true,
  type: 'call_list',
  description: DS.attr('string'),
  finishBy: DS.attr('date', {
    key: 'finish_by'
  }),
  user: DS.belongsTo('Radium.User', {key: 'user'}),
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
  contacts: DS.hasMany('Radium.Contact'),
  notes: DS.hasMany('Radium.Note', {embedded: true})
});