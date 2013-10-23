Radium.UploadFilelistComponent = Ember.Component.extend
  displayFiles: ( ->
    files = @get('files')
    ret = Ember.A()
    return Ember.A() unless files?.length
    for i in [0...files.length]
      ret.push files[i]

    ret
  ).property('files')
