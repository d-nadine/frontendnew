require 'lib/radium/buffered_proxy'

Radium.FieldEditorComponent = Ember.Component.extend
  actions:
    save: ->
      return if @get('isSaving')

      bufferedProxy = @get('bufferedProxy')

      return unless bufferedProxy.hasBufferedChanges

      parent = @get('targetObject')

      unless bufferedProxy.get('name.length')
        parent.send 'flashError', 'You must supply a value'
        @send 'cancel'

      @set 'isSaving', true

      bufferedProxy.applyBufferedChanges()

      self = this
      model = @get('model')

      model.save(@get('targetObject')).then((result) ->
        parent.send 'flashSuccess', 'The field has been updated.'

        self.set 'isSaving', false
        self.set 'isEditing', false
      ).catch (result) ->
        self.set 'isSaving', false
        @$('input[type=text]').focus()

      false

    edit: ->
      @set 'isEditing', true

      Ember.run.next =>
        @$('input[type=text]').focus()

      false

    cancel: ->
      @get('bufferedProxy').discardBufferedChanges()
      @set 'isEditing', false

      false

    delete: ->
      return if @get('isSaving')

      parent = @get('targetObject')

      @get('model').delete(@get('targetObject')).then (result) ->
        parent.send 'flashSuccess', 'The field has been deleted.'

      false

  keyDown: (e) ->
    return unless @$().length

    unless input = @$('input[type=text]')
      return

    return unless e.target == input.get(0)

    return unless e.keyCode == 13

    @send 'save'

  currentUser: Ember.computed ->
    @get('container').lookup('controller:currentUser').get('model')

  isValid: Ember.computed 'name', 'isEditing', ->
    return false unless @get('isEditing')

    name = @get('bufferedProxy.name')

    !Ember.isEmpty(name) && name.length

  bufferedProxy: Ember.computed 'model', ->
    BufferedObjectProxy.create content: @get('model')

  isEditing: false
  isSaving: false

  isAdmin: Ember.computed.oneWay 'currentUser.isAdmin'
