require 'lib/radium/autocomplete_list_view'

Radium.FormsEmailView = Radium.FormView.extend
  onFormReset: ->
    @$('form')[0].reset()

  attendees: Radium.AutocompleteView.extend()
