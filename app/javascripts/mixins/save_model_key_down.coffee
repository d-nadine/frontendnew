Radium.SaveModelKeyDownMixn = Ember.Mixin.create
  keyDown: (e) ->
    @_super.apply this, arguments

    return unless e.keyCode == @ENTER

    @sendAction('saveModel', e.target.value) if @get('saveModel')
