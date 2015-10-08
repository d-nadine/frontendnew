require 'mixins/inline_editor_behaviour'

Radium.InlineDropdownComponent = Ember.Component.extend Radium.InlineEditoBehaviour,
  actions:
    startEditing: ->
      @set 'form', Ember.Object.create value: @get('value')

      false

    stopEditing: ->
      return if @isDestroyed || @isDestroying
      @set 'isSubmitted', true

      return unless value = @get('form.value')

      @set 'isEditing', false

      @get('model').set(@get('key'), value)

      return unless @get('model.isDirty')

      @get('model').save()
        .finally => @get('isSubmitted', false)

      false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    key = "form.#{@get('key')}"

    Ember.defineProperty this, 'isValid', Ember.computed key, 'isSubmitted', ->
      @get('form.user')
