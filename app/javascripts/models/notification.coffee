Radium.Notification = DS.Model.extend
  createdAt: DS.attr("datetime", key: "created_at")
  updatedAt: DS.attr("datetime", key: "updated_at")
  tag: DS.attr("string")

  reference: Radium.polymorphic('reference')
  referenceType: DS.attr('string', key: 'reference.type')
