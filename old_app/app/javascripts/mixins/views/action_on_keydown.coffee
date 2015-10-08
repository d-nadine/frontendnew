Radium.ActionOnKeydown = Ember.Mixin.create
  actionHandler: null

  keyDown: (e) ->
    @_super.apply this, arguments

    return unless e.keyCode == 13

    Ember.assert "you need to supply an actionHandler property controller action", @actionHandler

    @get('targetObject').send @actionHandler