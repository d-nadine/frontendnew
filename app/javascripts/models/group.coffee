Radium.Group = Radium.Core.extend Radium.CommentsMixin,
  meta: DS.attr('object')
  name: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')
  isPublic: DS.attr('boolean')

  todos: DS.hasMany('Radium.Todo', inverse: 'group')
