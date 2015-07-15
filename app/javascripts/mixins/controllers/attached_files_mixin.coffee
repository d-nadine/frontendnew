Radium.AttachedFilesMixin = Ember.Mixin.create
  files: Ember.computed 'attachments.[]', 'model.files.[]', ->
    return @get('model.files') if @get('model.files')

    attachments = @get('attachments')

    Ember.assert "You need to have an attachments property", attachments

    attachments.uniq().map (attachment) -> Ember.Object.create(attachment: attachment)
