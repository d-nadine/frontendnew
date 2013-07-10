require 'forms/form'
require 'lib/radium/checklist_total_mixin'

Radium.DealForm = Radium.Form.extend Radium.ChecklistTotalMixin,
  data: ( ->
    name: @get('name')
    contact: @get('contact')
    user: @get('user')
    description: @get('description')
    source: @get('source')
    status: @get('status')
    value: @get('value')
    poNumber: @get('poNumber')
    isPublished: @get('isPublished')
  ).property().volatile()

  reset: () ->
    @_super.apply this, arguments
    @set('isSubmitted', false)
    @set('name', '')
    @set('description', '')
    @set('contact', null)
    @set('user', null)
    @set('source', '')
    @set('value', 0)
    @set('poNumber', '')
    @set('isPublished', true)
    @get('checklist').clear()

    return unless @get('form')

    @get('checklist').forEach (item) =>
      item.set('isFinished', false)

  isValid: ( ->
    return false if Ember.isEmpty(@get('name'))
    return false if Ember.isEmpty(@get('contact'))
    return false if Ember.isEmpty(@get('user'))
    return false if Ember.isEmpty(@get('description'))

    dealValue = @get('value')

    return false if Ember.isEmpty(dealValue)
    return false if parseInt(dealValue) == 0
    # FIXME: move into helper
    return false unless /^(?=.*[1-9])\d{0,5}(\.\d{1,2})?$/.test dealValue

    true
  ).property('name','contact','user','source','description', 'value')

  create:  ->
    deal = Radium.Deal.createRecord @get('data')

    @get('checklist').forEach (item) =>
      deal.get('checklist').createRecord item.getProperties('kind', 'description', 'weight', 'date', 'isFinished')

    deal
