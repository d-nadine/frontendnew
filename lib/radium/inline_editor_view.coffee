Radium.InlineEditorView = Ember.View.extend
  classNameBindings: ['view.isEditing:inline-editor-open:inline-editor-closed', ':inline-editor']
  isEditing: false

  # Clicking on the view will activate the editor.
  # Disable this if you want to activate
  # via a button or other UI element
  activateOnClick: true

  disabled: Ember.computed.not('isEditing')

  didInsertElement: ->
    $('body').on 'click.inline', =>
      return unless @get('isEditing')
      @toggleEditor()

  willDestroyElement: ->
    $('body').off 'click.inline'

  click: (event) -> 
    return unless @get('activateOnClick')
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
