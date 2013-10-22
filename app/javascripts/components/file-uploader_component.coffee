Radium.FileUploaderComponent = Ember.TextField.extend
  classNames: ['upload-button']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: true
  didInsertElement: ->
    @_super.apply this, arguments
