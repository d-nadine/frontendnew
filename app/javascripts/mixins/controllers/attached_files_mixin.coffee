Radium.AttachedFilesMixin = Ember.Mixin.create
  files: ( ->
    return @get('model.files') if @get('model.files') 
    @get('attachments').map (attachment) -> Ember.Object.create(attachment: attachment)
  ).property('attachments.[]', 'model.files.[]')
