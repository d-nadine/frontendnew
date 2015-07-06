Radium.AvatarPickerComponent = Ember.Component.extend
 actions:
    stopEditing: ->
      return if @isDestroyed || @isDestroying
      return if @get('isUploading')

      false

  isUploading: false
