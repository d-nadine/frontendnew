Radium.Notification = Radium.Core.extend
  createdAt: DS.attr("datetime")
  updatedAt: DS.attr("datetime")
  tag: DS.attr("string")

  reference: Radium.polymorphicAttribute()
  referenceType: (-> @get('referenceData.type') ).property('referenceData.type')
  referenceData: DS.attr('object')

  todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'reference')
  meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'reference')
  invitation: DS.belongsTo('Radium.Invitation', polymorphicFor: 'reference')
