require "components/x-autosuggest_component"

Radium.TagAutosuggestComponent = Radium.XAutosuggestComponent.extend
  actions:
    removeSelection: (tag) ->
      @sendAction "removeTag", tag

      false

  classNames: ['tags']
  showAvatar: false
  showAvatarInResults: false
  minChars: 0
  allowSpaces: true
  newItemCriteria: (text) ->
    re = /^(?=.*[^\W_])[\w\(\) ]{2,}$/
    re.test text

  selectionAdded: (tag) ->
    name = if typeof tag == "string" then tag else tag.get('name')

    @sendAction "addTag", name

  filterResults: (item) ->
    not @get('destination').mapProperty('name').contains(item.get('name'))

  focusOut: (e) ->
    input = @$('input[type=text]')
    text = input.val()

    return unless @newItemCriteria(text)

    @selectionAdded(text)
    input.val('').focus()
    false
