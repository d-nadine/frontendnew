require 'views/forms/email_view'

Radium.FormsForwardEmailView = Radium.FormsEmailView.extend
  didInsertElement: ->
    @get('toList').focus()
