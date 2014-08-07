Radium.ActivitiesAttachmentController = Radium.ActivityBaseController.extend
  attachment: Ember.computed.alias 'reference'
  attachedTo: Ember.computed.alias 'reference.reference'

  forContact: Radium.computed.kindOf 'attachment.reference', Radium.Contact
  forDeal: Radium.computed.kindOf 'attachment.reference', Radium.Deal

  isCreate: Ember.computed.equal 'event', 'create'
  isUpdate: Ember.computed.equal 'event', 'update'
  isDelete: Ember.computed.equal 'event', 'delete'

  icon: 'attach'

  company: Ember.computed.alias('attachedTo.company')
