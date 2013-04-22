Radium.InlineEditorView = Radium.View.extend
  classNameBindings: ['view.isEditing:inline-editor-open:inline-editor-closed', 'disabled:is-disabled:is-enabled', ':inline-editor']
  isEditing: false

  # Clicking on the view will activate the editor.
  # Disable this if you want to activate
  # via a button or other UI element
  activateOnClick: true

  isEditable: Ember.computed.alias('controller.isEditable')
  disabled: Ember.computed.not('isEditable')

  didInsertElement: ->
    $('body').on 'click.inline', =>
      return unless @get('isEditing')
      @toggleEditor()

  willDestroyElement: ->
    $('body').off 'click.inline'

  click: (event) -> 
    return unless @get('activateOnClick')
    return if @get('disabled')

    event.stopPropagation()
    @toggleEditor()

  toggleEditor: (event) ->
    if @get('isEditing') and @get('isValid')
      @set 'isEditing', false
    else
      @set 'isEditing', true

  isValid: (->
    value = @get 'value'
    return unless value
    true
  ).property('value')

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
