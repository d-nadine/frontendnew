Radium.Sms = Radium.Message.extend Radium.CommentsMixin,
  to: DS.attr('array')
  sender: DS.belongsTo('Radium.User')
  todos: DS.hasMany('Radium.Todo', inverse: 'sms')
