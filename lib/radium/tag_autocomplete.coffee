require 'lib/radium/autocomplete_list_view'

Radium.TagAutoComplete = Radium.AutocompleteView.extend
  actions:
    removeSelection: (tag) ->
      @get('controller').send 'removeSelection', tag

      false

  sourceBinding: 'controller.tagNames'
  listBinding: 'controller.controllers.tags'
  isEditable: true
  showAvatar: false
  showAvatarInResults: false
  minChars: 0
  newItemCriteria: (text) ->
    re = /^(?=.*[^\W_])[\w ]{3,}$/
    re.test text

  selectionAdded: (tag) ->
    name = if typeof tag == "string" then tag else tag.get('name')

    @get('controller').send('addTag', name)

  filterResults: (item) ->
    not @get('source').mapProperty('name').contains(item.get('name'))
