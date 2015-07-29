Radium.CustomfieldEditorComponent = Ember.Component.extend  Radium.KeyConstantsMixin,
  classNameBindings: [':sidebar-panel-content', ':custom-field', ':form', ':inline-editor']
  actions:
    save: ->
      return if @get('isSaving')

      @set 'isSaving', true

      customFieldValue = @get('customFieldValue')
      value = customFieldValue.get('value')
      parent = @get('parent')

      resource = @get('resource')
      customField = @get('field')

      if existing = resource.get('customFieldValues').find((f) -> f.get('customField') == customField)
        existing.set 'value', value
      else
        return @cancel() unless value?.length

        resource.get('customFieldValues').createRecord
          customField: customField
          value: value

      return @cancel() unless resource.get('isDirty')

      resource.save().then (result) =>
        unless @get('tableCell')
          parent.send 'flashSuccess', 'The field has been updated'

        return @cancel()

  customFieldValue: Ember.computed 'resource.customFieldMap', 'field', ->
    return unless customFieldMap = @get('resource.customFieldMap')

    field = @get('field')

    customFieldMap.get(field)

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    field = @get('field')

    Ember.assert "You must supply a custom field to a customfield-editor", field

    resource = @get('resource')

    Ember.assert "You must supply a resource to a customfield-editor", resource

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    return unless @get('tableCell')

    customFields = @get('customFields')

    return if @get("resource.customFieldMap")

    customFieldMap = @get('resource').getCustomFieldMap(customFields)

    @set "resource.customFieldMap", customFieldMap

  isEditing: false
  isSaving: false

  click: (e) ->
    return if ['A'].contains e.target.tagName

    return if @get('isEditing')

    @edit()

    e.stopPropagation()
    e.preventDefault()

    false

  edit: ->
    @set 'isEditing', true

    self = this

    Ember.run.next ->
      input = @$('.customfield-textinput')

      input.setCursorPosition().one 'blur', (e) ->
        Ember.run.next ->
          self.send 'save'

    false

  cancel: ->
    return if @isDestroying || @isDestroyed

    @set 'isSaving', false

    return if @get('tableCell')

    @set 'isEditing', false

  keyDown: (e) ->
    @_super.apply this, arguments

    return unless e.keyCode == @ENTER

    input = @$('.customfield-textinput')

    return unless input.length

    return if input.get(0).tagName == "TEXTAREA"

    @send 'save'

  focusOut: (e) ->
    return unless e.target.tagName == 'INPUT'

    return unless @get('tableCell')

    return unless e.target?.value?.length

    Ember.run.next =>
      @send "save"
