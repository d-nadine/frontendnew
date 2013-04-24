require 'lib/radium/autocomplete_list_view'

Radium.GroupAutoComplete = Radium.AutocompleteView.extend
  sourceBinding: 'controller.groups'
  listBinding: 'controller.controllers.groups'
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

  resizeInputBox: ->
    totalWidth = @$().outerWidth(true)

    selectionWidth = 0

    @$('li.as-selection-item').each ->
      selectionWidth = selectionWidth + $(this).outerWidth(true)

    inputWidth = totalWidth - selectionWidth - 157

    @$('li.as-original input').width inputWidth
