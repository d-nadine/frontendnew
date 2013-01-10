Radium.Attachment = Radium.Core.extend
  url: DS.attr('string')
  mimeType: DS.attr('string')

  attachable: Radium.polymorphicAttribute()
  attachableType: (-> @get('attachableData.type') ).property('attachableData.type')
  attachableData: DS.attr('object')

  # polymorphic types
  contact: DS.belongsTo('Radium.Contact', polymorphicFor: 'attachable')
  todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'attachable', inverse: 'todos')
  meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'attachable')
  group: DS.belongsTo('Radium.Group', polymorphicFor: 'attachable')
  deal: DS.belongsTo('Radium.Deal', polymorphicFor: 'attachable')
  email: DS.belongsTo('Radium.Email', polymorphicFor: 'attachable')
