require 'lib/radium/autocomplete_list_view'

Radium.FormsEmailView = Radium.FormView.extend
  onFormReset: ->
    @$('form')[0].reset()

  to: Radium.AutocompleteView.extend
    addCurrentUser: false
    sourceBinding: 'controller.to'
    showAvatar: false

  cc: Radium.AutocompleteView.extend
    addCurrentUser: false
    sourceBinding: 'controller.cc'
    showAvatar: false

  bcc: Radium.AutocompleteView.extend
    addCurrentUser: false
    sourceBinding: 'controller.bcc'
    showAvatar: false
