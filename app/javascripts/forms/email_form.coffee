require 'forms/form'

Radium.EmailForm = Radium.Form.extend
  data: ( ->
    subject: @get('subject')
    message: @get('message')
    sender: @get('user')
    to: []
    cc: []
    bcc: []
  ).property().volatile()



