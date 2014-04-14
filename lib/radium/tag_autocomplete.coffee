require 'lib/radium/autocomplete_list_view'

Radium.TagAutoComplete = Radium.AutocompleteView.extend
  actions:
    removeSelection: (tag) ->
      @get('controller').send 'removeSelection', tag

      false

  classNames: ['tags']
  sourceBinding: 'controller.tagNames'
  listBinding: 'controller.controllers.tags'
  isEditable: true
  showAvatar: false
  showAvatarInResults: false
  minChars: 0
  newItemCriteria: (text) ->
    re = /^(?=.*[^\W_])[\w ]{2,}$/
    re.test text

  selectionAdded: (tag) ->
    name = if typeof tag == "string" then tag else tag.get('name')

    @get('controller').send('addTag', name)

  filterResults: (item) ->
    not @get('source').mapProperty('name').contains(item.get('name'))

  focusOut: (e) ->
    input = @$('input[type=text]')
    text = input.val()

    return unless @newItemCriteria(text)

    @selectionAdded(text)
    input.val('').focus()
    false
