Radium.FormsNoteView = Radium.View.extend
  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @controller.EventBus.unsubscribe "note:formSubmitted"
