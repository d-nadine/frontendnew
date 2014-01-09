Radium.FormsAttachmentMixin = Ember.Mixin.create
  reset: ->
    @_super.apply this, arguments
    if @get('files')
      @get('files').clear()
    else
      @set 'files', Ember.A()

    @set('bucket', Math.random().toString(36).substr(2,9))

    if @get('attachedFiles')
      @get('attachedFiles').clear()
    else
      @set 'attachedFiles', Ember.A()

  setFilesOnModel: (model) ->
    @get('files').map( (file) -> file.get('attachment'))
        .forEach (attachment) =>
          model.get('attachedFiles').push(attachment.get('id'))
