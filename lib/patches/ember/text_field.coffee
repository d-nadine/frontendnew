Ember.TextField.reopen
  attributeBindings: ['min', 'readonly', 'autocomplete']
  # keyDown: (e) ->
  #   unless e.keyCode == 13
  #     @_super.apply this, arguments
  #     return

  #   e.preventDefault()
  #   e.stopPropagation()
