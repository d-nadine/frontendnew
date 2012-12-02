Radium.Reminder = Radium.Core.extend
  via: DS.attr('string')
  time: DS.attr('datetime')

  reference: Radium.polymorphicAttribute()

  todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'reference')
  meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'reference')
