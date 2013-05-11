Radium.CompanyController = Radium.ObjectController.extend
  needs: ['users', 'leadStatuses',  'tags', 'companies', 'countries']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'

  # FIXME: How do we determine this?
  isEditable: true

  changeStatus: ->
    # @set('changingStatus', true)
    @get('contacts').setEach 'status', @get('status')
    @get('store').commit()

