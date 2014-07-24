Radium.InlineEditorView = Ember.View.extend
  actions:
    toggleEditor:  ->
      if @get('isEditing') and @get('isValid')
        @get('controller').send 'stopEditing'
      else
        @get('controller').send 'startEditing'

      return unless @get 'isEditing'
      Ember.run.scheduleOnce 'afterRender', this, 'highlightSelection'

  classNameBindings: ['isEditing:inline-editor-open:inline-editor-closed', 'disabled:is-disabled:is-enabled', ':inline-editor']

  isEditing: Ember.computed.alias 'controller.isEditing'
  isValid: Ember.computed.alias 'controller.isValid'

  # Clicking on the view will activate the editor.
  # Disable this if you want to activate
  # via a button or other UI element
  activateOnClick: true

  isEditable: Ember.computed.alias('controller.isEditable')
  disabled: Ember.computed.not('isEditable')

  didInsertElement: ->
    $('body').on 'click.inline', =>
      return unless @get('isEditing')
      @send 'toggleEditor'

  willDestroyElement: ->
    $('body').off 'click.inline'

  change: (evt) ->
    @$().trigger 'click' if evt.target.tagName == 'SELECT'

  click: (evt) ->
    return unless @get('activateOnClick')
    return if @get('disabled')

    if evt.target?.type == 'file'
      event.stopPropagation()
      return

    tagName = evt.target.tagName.toLowerCase()

    if (['input', 'button',  'select', 'i', 'a'].indexOf(tagName) == -1) || $(evt.target).hasClass('resource-name')
      event.stopPropagation()
      @send 'toggleEditor'
      return

    return if tagName == 'a' && evt.target?.target == "_blank"

    evt.preventDefault()
    evt.stopPropagation()

  highlightSelection: ->
    textField = @$('input[type=text],textarea').filter(':first')

    return unless textField.length

    Ember.run.later =>
      textField.focus()
      textField.get(0).select()
    , 200

  keyDown: (evt) ->
    return unless evt.target.tagName.toLowerCase() == 'input'

    return if [13, 9].indexOf(evt.keyCode) == -1

    @send 'toggleEditor'
    return false

  textField: Ember.TextField.extend
    isEditing: Ember.computed.alias('parentView.isEditing')

    placeholder: (-> @get('value')).property()

    click: (event) ->
      event.stopPropagation() if @get 'isEditing'

    insertNewline: ->
      @get('parentView').send 'toggleEditor'

  textArea: Ember.TextArea.extend
    isEditing: Ember.computed.alias('parentView.isEditing')

    placeholder: (-> @get('value')).property()

    click: (event) ->
      event.stopPropagation() if @get 'isEditing'

  template: Ember.Handlebars.compile """
    {{#if view.isEditing}}
      {{view view.textField valueBinding="view.value"}}
    {{else}}
      <span class="inline-editor-text">{{view.value}}</span>
    {{/if}}
  """
