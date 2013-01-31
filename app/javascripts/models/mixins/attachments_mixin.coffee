Radium.AttachmentsMixin = Ember.Mixin.create
  attachments: DS.hasMany('Radium.Attachment')

  hasAttachments: (->
    @get('attachments.length') isnt 0
  ).property('attachments.length')
