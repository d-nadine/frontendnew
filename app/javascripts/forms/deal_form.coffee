require 'forms/form'

Radium.DealForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    contact: @get('contact')
  ).property().volatile()
