Radium.InlineEditoBehaviour = Ember.Mixin.create
  classNameBindings: ['isEditing:inline-editor-open', ':editor']

  isEditing: false
  isSaving: false
  isSubmitted: false
  isInvalid: false
  errorMessages: Ember.A()

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    $(document).on 'click.inline', (e) =>
      return unless @get('isEditing')

      target = $(e.target)
      tagName = e.target.tagName.toLowerCase()

      if ['x-check', 'new-comment', 'address-switcher'].any((c) -> target.hasClass(c))
        return

      if tagName == "input" && ['radio', 'checkbox'].contains(target.attr('type'))
        return

      if (!['input', 'button',  'select', 'i', 'a'].contains(tagName)) || target.hasClass('resource-name')
        @send 'stopEditing'
        return

      return if tagName == 'a' && e.target?.target == "_blank"

      e.preventDefault()
      e.stopPropagation()
      false

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    $(document).off 'click.inline'

  stopPropagation: (e) ->
    e.stopPropagation()
    e.preventDefault()
    return false

  click: (e) ->
    unless @get('isEditing')
      @set 'isEditing', true
      @send 'startEditing'
      return @stopPropagation(e)
