require 'lib/radium/autocomplete_list_view'

Radium.TagAutoComplete = Radium.AutocompleteView.extend
  sourceBinding: 'controller.tags'
  listBinding: 'controller.controllers.tags'
  isEditableBinding: 'controller.isNew'
  showAvatar: false
  showAvatarInResults: false
  newItemCriteria: (text) ->
    re = /^(?=.*[^\W_])[\w ]{3,}$/
    re.test text

  selectionAdded: (item) ->
    if typeof item == "string"
      item = Ember.Object.create
                name: item

    @get('parentView').addSelection item
