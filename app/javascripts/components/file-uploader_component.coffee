Radium.FileUploaderComponent = Ember.TextField.extend
  classNames: ['upload-button']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: true
  change: (e) ->
    input = e.target
    return if Ember.isEmpty(input.files)
    @set('uploadTo.files', input.files)
