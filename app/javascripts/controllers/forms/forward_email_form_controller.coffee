Radium.FormsForwardEmailController = Radium.FormsEmailController.extend
  expand: ->
    @toggleProperty 'isExpanded'

  submit: (form) ->
    @send 'forward', form
