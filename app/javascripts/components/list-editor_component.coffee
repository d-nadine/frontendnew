Radium.ListEditorComponent = Ember.Component.extend
  listLabel: Ember.computed 'list', ->
    if @get('list.isNew')
      "New"
    else
      "Edit"
