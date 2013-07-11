Radium.SidebarTagsView = Radium.View.extend
  tags: Radium.TagAutoComplete.extend
    placeholder: 'Add'
    sourceBinding: 'controller.tagNames'
