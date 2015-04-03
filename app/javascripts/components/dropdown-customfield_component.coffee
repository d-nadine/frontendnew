Radium.DropdownCustomfieldComponent = Ember.Component.extend
  actions:
    modifyCustomFields: (item) ->
      @sendAction "modifyCustomFields", item
