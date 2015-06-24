Radium.InlineSaveEditor = Ember.Mixin.create
  actions:
    startEditing: ->
      @set('form', Ember.Object.create(value: @get('model').get(@get('key'))))

      false

    stopEditing: ->
      @set 'isSubmitted', true

      return unless value = @get('form.value')

      @set 'isEditing', false

      @get('model').set(@get('key'), value)

      return unless @get('model.isDirty')

      @get('model').save()
        .finally => @get('isSubmitted', false)

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set('form', Ember.Object.create(value: @get('model').get(@get('key'))))
