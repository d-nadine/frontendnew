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

    return if @get('source').find (existing) ->
      existing.get('name') == name

    if typeof tag == "string"
      if @get('controller.isNew') || (!@get('source').createRecord)
        tag = Ember.Object.create
                  name: tag
      else
        tag = @get('source').createRecord
            name: tag

    @get('parentView').addSelection tag
