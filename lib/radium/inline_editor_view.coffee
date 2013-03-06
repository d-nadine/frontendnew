Radium.InlineEditorView = Ember.View.extend
  isEditing: false

  disabled: Ember.computed.not('isEditing')

  didInsertElement: ->
    $('body').on 'click.inline', =>
      return unless @get('isEditing')
      @toggleEditor()

  willDestroyElement: ->
    $('body').off 'click.inline'

  click: (event) -> 
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

  template: """
    <div {{bindAttr class="view.isEditing:inline-editor-open:inline-editor-closed :inline-editor"}}>
      {{#if view.isEditing}}
        {{view view.textField valueBinding=view.value}}
      {{else}}
        <span class="inline-editor-text">{{view.value}}</span>
      {{/if}}
    </div>
  """
