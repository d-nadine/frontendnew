Radium.InlineEditorBase = Ember.Component.extend
  actions:
    selectContent: ->
      el = @$('.editable-field-component')

      later = Ember.run.later ->
        el.selectText()
        Ember.run.cancel later
      , 10

      false
