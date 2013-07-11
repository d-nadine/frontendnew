require 'lib/radium/autocomplete_list_view'

Radium.TagAutoComplete = Radium.AutocompleteView.extend
  sourceBinding: 'controller.tags'
  listBinding: 'controller.controllers.tags'
  isEditable: true
  showAvatar: false
  showAvatarInResults: false
  newItemCriteria: (text) ->
    re = /^(?=.*[^\W_])[\w ]{3,}$/
    re.test text

  selectionAdded: (tag) ->
    name = if typeof tag == "string" then tag else tag.get('name')

    @get('controller').addTag name
