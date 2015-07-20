Radium.AttachedFilesMixin = Ember.Mixin.create
  files: Ember.computed 'model.attachments.[]', 'attachments.[]', 'model.files.[]', ->
    return unless model = @get('model')

    files = model.get('files')

    return files if files

    attachments = @get('attachments') || model.get('attachments')

    Ember.assert "You need to have an attachments property", attachments

    attachments.uniq().map (attachment) -> Ember.Object.create(attachment: attachment)
