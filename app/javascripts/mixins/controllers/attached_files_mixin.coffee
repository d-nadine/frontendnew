Radium.AttachedFilesMixin = Ember.Mixin.create
  files: Ember.computed 'attachments.[]', 'model.files.[]', ->
    return unless attachments = @get('attachments')

    return @get('model.files') if @get('model.files')

    attachments.uniq().map (attachment) -> Ember.Object.create(attachment: attachment)
