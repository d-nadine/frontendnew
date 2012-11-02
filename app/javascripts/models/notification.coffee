Radium.Notification = DS.Model.extend
  createdAt: DS.attr("datetime")
  updatedAt: DS.attr("datetime")
  tag: DS.attr("string")

  reference: Radium.polymorphic('reference')
  referenceTypeBinding: 'referenceData.type'
  referenceData: DS.attr('object')
