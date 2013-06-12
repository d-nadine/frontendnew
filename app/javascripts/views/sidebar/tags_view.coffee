Radium.SidebarTagsView = Radium.View.extend
  tags: Radium.TagAutoComplete.extend
    placeholder: 'Add'
    sourceBinding: 'controller.tags'

    selectionAdded: (item) ->
      @get('controller').addTag item
