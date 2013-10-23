Radium.FileUploaderComponent = Ember.TextField.extend
  classNames: ['upload-button']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: true
  change: (e) ->
    files = e.target.files
    return if Ember.isEmpty(files)
    uploadToFiles = @get('files')

    for i in [0...files.length]
      file = files[i]
      fileWrapper = Ember.Object.create(file, file: file)
      uploadToFiles.pushObject(fileWrapper)
