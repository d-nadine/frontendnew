Radium.SidebarTagsView = Radium.View.extend
  tags: Radium.TagAutoComplete.extend
    placeholder: 'Add'
    sourceBinding: 'controller.tagNames'

    selectionAdded: (item) ->
      @get('controller').addTag item
