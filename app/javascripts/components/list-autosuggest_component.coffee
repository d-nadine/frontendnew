require "components/x-autosuggest_component"

Radium.ListAutosuggestComponent = Radium.XAutosuggestComponent.extend
  actions:
    addSelection: (list) ->
      @sendAction "addList", list

      false

    removeSelection: (list) ->
      @sendAction "removeList", list

      false

  classNames: ['tags']
  showAvatar: false
  showAvatarInResults: false
  minChars: 0
  allowSpaces: true
  newItemCriteria: (text) ->
    re = /^(?=.*[^\W_])[\w\(\) ]{2,}$/
    re.test text

  filterResults: (item) ->
    not @get('destination').mapProperty('name').contains(item.get('name'))

  focusOutHandler: (e) ->
    false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    Ember.assert "You must set a destination in the ListAutosuggestComponent", @get('destination')
