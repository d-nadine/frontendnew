Radium.AttachmentsMixin = Ember.Mixin.create
  attachments: DS.hasMany('Radium.Attachment')
  attachedFiles: DS.attr('array')

  hasAttachments: Ember.computed 'attachments.length', ->
    @get('attachments.length')
