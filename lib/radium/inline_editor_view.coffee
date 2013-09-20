Radium.InlineEditorView = Ember.View.extend
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
      Ember.run.next(->
        Ember.$(window).trigger 'stickyChange'
      )
      return unless @get('isEditing')
      @toggleEditor()

  willDestroyElement: ->
    $('body').off 'click.inline'

  change: (evt) ->
    @$().trigger 'click' if evt.target.tagName == 'SELECT'

  click: (evt) ->
    Ember.run.next(->
      Ember.$(window).trigger 'stickyChange'
    )

    return unless @get('activateOnClick')
    return if @get('disabled')

    unless @get('isEditing')
      event.stopPropagation()
      @toggleEditor()
      return

    tagName = evt.target.tagName.toLowerCase()

    if ['input', 'button', 'span',  'select', 'i', 'a'].indexOf(tagName) == -1
      event.stopPropagation()
      @toggleEditor()
      return

    evt.preventDefault()
    evt.stopPropagation()


  toggleEditor:  ->
    if @get('isEditing') and @get('isValid')
      @get('controller').stopEditing()
    else
      @get('controller').startEditing()

    return unless @get 'isEditing'
    Ember.run.scheduleOnce 'afterRender', this, 'highlightSelection'

  highlightSelection: ->
    @$('input[type=text],textarea').filter(':first').focus()

  keyDown: (evt) ->
    return unless evt.target.tagName.toLowerCase() == 'input'

    return if [13, 9].indexOf(evt.keyCode) == -1

    @toggleEditor()

  textField: Ember.TextField.extend
    isEditing: Ember.computed.alias('parentView.isEditing')

    placeholder: (-> @get('value')).property()

    click: (event) ->
      event.stopPropagation() if @get 'isEditing'

    insertNewline: ->
      @get('parentView').toggleEditor()

  textArea: Ember.TextArea.extend
    isEditing: Ember.computed.alias('parentView.isEditing')

    placeholder: (-> @get('value')).property()

    click: (event) ->
      event.stopPropagation() if @get 'isEditing'

  template: Ember.Handlebars.compile """
    {{#if view.isEditing}}
      {{view view.textField valueBinding=view.value}}
    {{else}}
      <span class="inline-editor-text">{{view.value}}</span>
    {{/if}}
  """
