require 'forms/form'
Radium.DiscussionForm = Radium.Form.extend
  data: ( ->
    text: @get('text')
  ).property().volatile()

  isValid: ( ->
    not Ember.isEmpty('text')
  ).property()
