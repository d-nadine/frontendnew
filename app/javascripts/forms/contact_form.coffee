require 'forms/form'

Radium.ContactForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    assignedTo: @get('assignedTo')
  ).property().volatile()
