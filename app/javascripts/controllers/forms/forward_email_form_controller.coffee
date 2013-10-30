Radium.FormsForwardEmailController = Radium.FormsEmailController.extend
  actions:
    expand: ->
      @toggleProperty 'isExpanded'
      false

    submit: (form) ->
      @send 'forward', form
