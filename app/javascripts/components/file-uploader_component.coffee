Radium.FileUploaderComponent = Ember.TextField.extend
  type: 'file'
  attributeBindings: ['multiple']
  multiple: true
  didInsertElement: ->
    @_super.apply this, arguments
