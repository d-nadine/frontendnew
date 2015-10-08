require 'mixins/inline_editor_behaviour'
require 'mixins/inline_save_editor'

Radium.InlineMoneyComponent = Ember.Component.extend Radium.InlineEditoBehaviour,
  Radium.InlineSaveEditor

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    key = "form.#{@get('key')}"

    Ember.defineProperty this, 'isValid', Ember.computed key, 'isSubmitted', ->
      @get('form.value')

  classNameBindings: [':amount']
