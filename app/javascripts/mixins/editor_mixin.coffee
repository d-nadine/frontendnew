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

  insertActions: Ember.computed  ->
    placeholderMap = Radium.TemplatePlaceholderMap
    customFields = @get('customFields') || []

    ret = Ember.A()

    for i of placeholderMap
      if placeholderMap.hasOwnProperty(i)
        display = placeholderMap[i]
        item = Ember.Object.create(name: i, display: "{#{display}}", curlyless: display)
        ret.pushObject item

    ret

  customFieldPlaceholders: Ember.computed 'customFields.[]', ->
    ret = Ember.A()

    customFields = @get('customFields') || Ember.A()

    unless customFields.get('length')
      return ret

    customFields.map (field) ->
      Ember.Object.create(field: field, display: "{#{field.get('name')}}")

  allPlaceholders: Ember.computed 'insertActions.[]', 'customFieldPlaceholders.[]', ->
    insertActions = @get('insertActions') || Ember.A()
    customFieldPlaceholders = @get('customFieldPlaceholders') || Ember.A()

    insertActions.concat customFieldPlaceholders