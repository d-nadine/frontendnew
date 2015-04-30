Radium.TemplatePlaceholderMap =
  "name": "name"
  "first_name": "first name"
  "last_name": "last name"
  "company_name": "company"
  "signature": "signature"

Radium.EditorMixin = Ember.Mixin.create
  actions:
    insertPlaceholder: (placeholder) ->
      @EventBus.publish('placeholderInsered', placeholder)

      false

    toggleEditorToolbar: ->
      @$('.note-toolbar').slideToggle "slow"

    insertCustomFieldPlaceholder: (field) ->
      @EventBus.publish("customFieldInserted", field)

      false

  insertActions: Ember.computed 'customFields.[]', ->
    placeholderMap = Radium.TemplatePlaceholderMap
    customFields = @get('customFields') || []

    ret = Ember.A()

    for i of placeholderMap
      if placeholderMap.hasOwnProperty(i)
        item = Ember.Object.create(name: i, display: "{#{placeholderMap[i]}}")
        ret.pushObject item

    unless customFields.get('length')
      return ret

    customFields.forEach (field) ->
      item = Ember.Object.create(field: field, display: "{#{field.get('name')}}")

      ret.pushObject item

    ret
