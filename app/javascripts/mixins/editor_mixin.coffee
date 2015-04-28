Radium.TemplatePlaceholderMap =
  "name": "name"
  "company": "company"
  "signature": "signature"

Radium.EditorMixin = Ember.Mixin.create
  actions:
    insertPlaceholder: (placeholder) ->
      @EventBus.publish('placeholderInsered', placeholder)
      false

    toggleEditorToolbar: ->
      @$('.note-toolbar').slideToggle "slow"

  insertActions: Ember.computed ->
    placeholderMap = Radium.TemplatePlaceholderMap

    ret = Ember.A()

    for i of placeholderMap
      if placeholderMap.hasOwnProperty(i)
        item = Ember.Object.create(name: i, display: "{#{placeholderMap[i]}}")
        ret.pushObject item

    ret
