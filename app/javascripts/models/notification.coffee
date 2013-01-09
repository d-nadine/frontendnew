Radium.Notification = Radium.Core.extend
  createdAt: DS.attr("datetime")
  updatedAt: DS.attr("datetime")
  tag: DS.attr("string")

  reference: Radium.polymorphicAttribute()
  referenceType: (-> @get('referenceData.type') ).property('referenceData.type')
  referenceData: DS.attr('object')

  contact: DS.belongsTo('Radium.Contact', polymorphicFor: 'reference')
  deal: DS.belongsTo('Radium.Deal', polymorphicFor: 'reference')
  group: DS.belongsTo('Radium.Group', polymorphicFor: 'reference')
  todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'reference')
  meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'reference')
  invitation: DS.belongsTo('Radium.Invitation', polymorphicFor: 'reference')
