require 'controllers/form_array_behaviour'

Radium.MultipleBaseComponent = Ember.Component.extend Radium.FormArrayBehaviour,
  actions:
    startEditing: ->
      return if @get('isSaving')

      @set 'isEditing', true

      arr = @get(@relationship)

      @createFormFromRelationship @get('model'), @relationship, arr

      false

    stopEditing: ->
      @set 'isSaving', true
      @set 'isSubmitted', true

      Ember.run.next =>
        errorMessages = @get('errorMessages')

        if errorMessages.get('length')
          return @get('errorMessages').clear()

        arr = @get(@relationship)

        model = @get("model")

        @setModelFromHash(model, @relationship, arr)

        finish = =>
          @get(@relationship).clear()
          @set 'isEditing', false
          @set 'isSaving', false
          @set 'isSubmitted', false
          @get('errorMessages').clear()

        unless model.get('isDirty')
          finish()

        self = this

        model.save( ->
          self.set 'isSubmitted', false
          self.get('errorMessages').clear()
        ).then(finish).finally ->
          self.set 'isSaving', false

      false

  classNameBindings: ['isEditing:inline-editor-open']

  isEditing: false
  isSaving: false
  isSubmitted: false
  isInvalid: false
  errorMessages: Ember.A()

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    $(window).on 'click.inline', (e) =>
      return unless @get('isEditing')

      target = $(e.target)
      tagName = e.target.tagName.toLowerCase()

      if (!['input', 'button',  'select', 'i', 'a'].contains(tagName)) || target.hasClass('resource-name')
        @send 'stopEditing'
        return

      return if tagName == 'a' && e.target?.target == "_blank"

      e.preventDefault()
      e.stopPropagation()
      false

  stopPropagation: (e) ->
    e.stopPropagation()
    e.preventDefault()
    return false

  click: (e) ->
    unless @get('isEditing')
      @set 'isEditing', true
      @send 'startEditing'
      return @stopPropagation(e)
