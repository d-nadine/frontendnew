Radium.CustomfieldPlaceholdersComponent = Ember.Component.extend
  actions:
    insertCustomFieldPlaceholder : (field) ->
      @sendAction "insertCustomFieldPlaceholder", field

  tagName: 'ul'
  classNames: ['dropdown-menu']
