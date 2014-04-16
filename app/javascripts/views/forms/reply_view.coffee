require 'views/forms/email_view'

Radium.FormsReplyView = Radium.FormsEmailView.extend
  classNames: ['forms-email-view']
  templateName: "forms/email"

  scrollToTop: ->
    undefined
