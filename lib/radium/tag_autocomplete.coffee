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

  selectionAdded: (item) ->
    return if @get('source').find (existing) ->
      existing.get('name') == item.get('name')

    if typeof item == "string"
      if @get('controller.isNew') || (!@get('source').createRecord)
        item = Ember.Object.create
                  name: item
      else
        item = @get('source').createRecord
            name: item

    @get('parentView').addSelection item
