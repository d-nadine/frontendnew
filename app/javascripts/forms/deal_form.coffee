require 'forms/form'

Radium.DealForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    contact: @get('contact')
  ).property().volatile()

  reset: ->
    @_super.apply this, arguments
    @set('contact', null)
    @set('contact', null)
    @set('contact', null)

  isValid: ( ->
    return if Ember.isEmpty(@get('name'))
    return if Ember.isEmpty(@get('value'))

    true
  ).property('name', 'value')

   commit:  ->
    deal = Radium.Contact.createRecord @get('data')

    @get('store').commit()

    deal
