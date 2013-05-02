Radium.ActivitiesAttachmentController = Radium.ObjectController.extend
  attachment: Ember.computed.alias 'reference'
  attachedTo: Ember.computed.alias 'reference.reference'

  forContact: Radium.computed.kindOf 'attachment.reference', Radium.Contact
  forDeal: Radium.computed.kindOf 'attachment.reference', Radium.Deal
  forDiscussion: Radium.computed.kindOf 'attachment.reference', Radium.Discussion

  isCreate: Ember.computed.equal 'meta.event', 'create'
  isUpdate: Ember.computed.equal 'meta.event', 'update'
  isDelete: Ember.computed.equal 'meta.event', 'delete'
