require 'mixins/inline_editor_behaviour'
require 'mixins/inline_save_editor'

Radium.DealStatusComponent = Ember.Component.extend Radium.InlineEditoBehaviour,
  Radium.InlineSaveEditor,
  actions:
    changeStatus: (status) ->
      @set 'isSubmitted', true

      return if status == @get('model.status')

      commit =  =>
        if status == 'lost'
          @set 'model.lostDuring', @get('model.status')

        @get('model').save().then =>
          @set 'isEditing', false

      @set 'model.status', status

      if status == "lost"
        route = @container.lookup('route:deal')
        route.send 'showStatusChangeConfirm', this, commit
      else
        commit()

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'lostBecause', null
    key = "form.#{@get('key')}"

    Ember.defineProperty this, 'isValid', Ember.computed key, 'isSubmitted', ->
      @get('form.value')
