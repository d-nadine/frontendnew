Radium.TemplatePlaceholderMap =
  "name": "name"
  "first_name": "first name"
  "last_name": "last name"
  "company_name": "company"
  "signature": "signature"

Radium.FallbackMap =
  "name": "Hi there"
  "first_name": ""
  "last_name": ""
  "company_name": "your company"
  "signature": "Best Regards"

Radium.EditorMixin = Ember.Mixin.create
  actions:
    insertTemplate: (template) ->
      @EventBus.publish "insertTemplate", template

      if template.get('attachments.length')
        template.get('attachments').forEach (attachment) =>
          @get('form.files').pushObject Ember.Object.create(attachment: attachment)

      false

    insertPlaceholder: (placeholder) ->
      if placeholder.template
        @send 'insertTemplate', placeholder.template
      else
        @EventBus.publish('placeholderInserted', placeholder)

      false

    toggleEditorToolbar: ->
      @$('.note-toolbar').slideToggle "slow"
      @$('.note-toolbar').toggleClass "toolbar-open"

    insertCustomFieldPlaceholder: (field) ->
      @EventBus.publish("customFieldInserted", field)

      false

  insertActions: Ember.computed ->
    placeholderMap = Radium.TemplatePlaceholderMap
    customFields = @get('customFields') || []

    ret = Ember.A()

    for i of placeholderMap
      if placeholderMap.hasOwnProperty(i)
        display = placeholderMap[i]
        item = Ember.Object.create(name: i, display: "{#{display}}", curlyless: display)
        ret.pushObject item

    templates = @get('templates').toArray()

    return ret unless templates.get('length')

    templateOptions = templates.map (template) ->
      display = template.get('subject')
      Ember.Object.create(name: display, display: "{#{display}}", curlyless: display, template: template)

    ret.pushObjects(templateOptions)

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
