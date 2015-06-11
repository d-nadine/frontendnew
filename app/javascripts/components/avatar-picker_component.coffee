Radium.AvatarPickerComponent = Ember.Component.extend
 actions:
   startEditing: ->
     @set 'isEditing', true

     false

    stopEditing: ->
      return if @get('isUploading')
      @set 'isEditing', false

      false

  isEditing: false
  isUploading: false
