Radium.FormsForwardEmailController = Radium.FormsEmailController.extend
  actions:
    expand: ->
      @toggleProperty 'isExpanded'

    submit: (form) ->
      @send 'forward', form
