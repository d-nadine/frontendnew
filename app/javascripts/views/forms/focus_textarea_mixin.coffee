Radium.FocusTextareaMixin = Ember.Mixin.create
  init: ->
    @_super.apply this, arguments
    if parentController = @get('controller.parentController')
      parentController.on('focusTopic', this, 'onFocusTopic')

  onFocusTopic: ->
    @$('textarea')?.focus()
