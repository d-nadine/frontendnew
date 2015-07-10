Radium.AttachedFilesMixin = Ember.Mixin.create
  files: Ember.computed 'attachments.[]', 'model.files.[]', ->
    return @get('model.files') if @get('model.files')

    @get('attachments').uniq().map (attachment) -> Ember.Object.create(attachment: attachment)
