Radium.FolderItemComponent = Ember.Component.extend
  actions:
    selectFolder: (folder) ->
      @get('parent').send "selectFolder", folder

      false
