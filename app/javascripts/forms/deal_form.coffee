require 'forms/form'
require 'lib/radium/checklist_total_mixin'

Radium.DealForm = Radium.Form.extend Radium.ChecklistTotalMixin,
  Radium.FormsAttachmentMixin,
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
    expectedCloseDate: @get('expectedCloseDate')
    attachedFiles: Ember.A()
    bucket: @get('bucket')
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
    @set('expectedCloseDate', null)
    @set('isPublished', true)
    @get('checklist').clear()

    return unless @get('form')

    @get('checklist').forEach (item) ->
      item.set('isFinished', false)

  create:  ->
    deal = Radium.Deal.createRecord @get('data')

    @setFilesOnModel(deal)

    @get('checklist').forEach (item) =>
      deal.get('checklist').createRecord item.getProperties('kind', 'description', 'weight', 'date', 'isFinished')

    deal
