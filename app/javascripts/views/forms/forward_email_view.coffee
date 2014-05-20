require 'views/forms/email_view'

Radium.FormsForwardEmailView = Radium.FormsEmailView.extend
  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', this, 'setUp'

  setUp: ->
    @get('toList').$('input[type=text]').focus()
