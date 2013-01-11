Radium.Group = Radium.Core.extend Radium.FollowableMixin,
  name: DS.attr('string')

  todos: DS.hasMany('Radium.Todo', inverse: 'group')
