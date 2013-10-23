Radium.UploadFilelistComponent = Ember.Component.extend
  actions:
    removeFile: (file) ->
      @get('files').removeObject(file)
