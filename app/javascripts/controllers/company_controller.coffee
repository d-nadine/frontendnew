Radium.CompanyController = Radium.ObjectController.extend
  needs: ['users', 'leadStatuses',  'tags', 'companies', 'countries']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'

  # FIXME: How do we determine this?
  isEditable: true

  changeStatus: ->
    # @set('changingStatus', true)
    @get('contacts').setEach 'status', @get('status')
    @get('store').commit()

  maxContactsStatus: ( ->
    contacts = @get('contacts')

    return unless contacts.get('length')

    maxStatus = -1

    statuses = @get('leadStatuses').map (status) ->
                status.value

    contacts.forEach (contact) ->
      index = statuses.indexOf contact.get('status')

      if index > maxStatus
        maxStatus = index

    @get('leadStatuses').objectAt(maxStatus).name
  ).property('contacts.[]')
