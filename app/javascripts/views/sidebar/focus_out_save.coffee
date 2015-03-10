Radium.FocusOutSaveMixin = Ember.Mixin.create
  focusOut: (e) ->
    return unless e.target.tagName == 'INPUT'
    controller = @get('controller')
    return unless controller._actions.commit
    @get('controller').send 'commit', true
