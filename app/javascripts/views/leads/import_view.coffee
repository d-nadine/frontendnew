Radium.LeadsImportView = Radium.View.extend
  tags: Radium.TagAutoComplete.extend
    placeholder: 'Add tags for each contact'
    sourceBinding: 'controller.tagNames'
