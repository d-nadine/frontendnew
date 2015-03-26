require 'lib/radium/buffered_proxy'

Radium.FieldEditorComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  actions:
    save: (noRetry) ->
      return if @get('isSaving')

      bufferedProxy = @get('bufferedProxy')

      return unless bufferedProxy

      unless bufferedProxy.hasBufferedChanges
        return @send 'cancel'

      parent = @get('parent')
      model = @get('model')

      unless bufferedProxy.get('name.length')
        parent.send 'flashError', 'You must supply a value'
        @set 'isSaving', false

        return if model.get('isNew')

        return @send 'cancel'

      @set 'isSaving', true

      bufferedProxy.applyBufferedChanges()

      if @get('saveModel')
        return @sendAction "saveModel"

      self = this

      model.save(parent).then((result) ->
        parent.send 'flashSuccess', 'The field has been updated.'

        self.set 'isSaving', false
        self.set 'isEditing', false
      ).catch (result) =>
        self.set 'isSaving', false
        @$('input[type=text]').focus()
        bufferedProxy.set 'name', result.get('_data.name')
        bufferedProxy.applyBufferedChanges()
        model.save(self)
      false

    edit: ->
      @set 'isEditing', true

      self = this
      Ember.run.next ->
        self.$('input[type=text]').select().focus().one 'blur', (e) ->
          Ember.run.next ->
            self.send 'save'

      return unless @get('model.isNew')

      @get('bufferedProxy').set 'name', ''

      false

    cancel: ->
      model = @get('model')

      if model.get('isNew') && @get('cancelModel')
        return @sendAction 'cancelModel', model

      if model.get('isNew') && model.unloadRecord
        return model.unloadRecord()

      @get('bufferedProxy').discardBufferedChanges()
      @set 'isSaving', false
      @set 'isEditing', false
      false

    delete: ->
      return if @get('isSaving')

      model = @get('model')

      if @get('deleteModel')
        return @sendAction 'deleteModel', model

      if model.get('isNew')
        return model.unloadRecord()

      parent = @get('parent')

      model.delete(parent).then (result) ->
        parent.send 'flashSuccess', 'The field has been deleted.'

      false

  click: (e) ->
    return if @get('isEditing')

    target = $(e.target)

    #return @send('edit') if target.hasClass('ss-write')

    return true if ["BUTTON", "A"].contains target.get(0).tagName

    return true if $(target).hasClass('btn-remove-field')

    return unless @get('isAdmin')

    @send 'edit'

    e.stopPropagation()
    e.preventDefault()
    false

  keyDown: (e) ->
    return unless @$().length

    unless input = @$('input[type=text]')
      return

    return unless e.target == input.get(0)

    return unless e.keyCode == @ENTER

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

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    stopEditing = @stopEditing.bind(this)
    $('body').on 'click.field-input', stopEditing

    return unless @get('model.isNew')

    Ember.run.scheduleOnce 'afterRender', this, 'triggerEdit'

  stopEditing: (e) ->
    return unless @get('isEditing')

    if ["BUTTON", "A"].contains e.target.tagName
      return $(e.relatedTarget).click()

    @send 'save'

  teardown: Ember.on 'willDestroyElement', ->
    $('body').off 'click.field-input'

  triggerEdit: ->
    @send 'edit'
