Radium.Comment = Radium.Core.extend
  text: DS.attr('string')

  commentable: Radium.polymorphicAttribute()
  user: DS.belongsTo('Radium.User', inverse: 'comments')

  todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'commentable')
  meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'commentable')
  deal: DS.belongsTo('Radium.Deal', polymorphicFor: 'commentable')
  phoneCall: DS.belongsTo('Radium.PhoneCall', polymorphicFor: 'commentable')
  email: DS.belongsTo('Radium.Email', polymorphicFor: 'commentable')
