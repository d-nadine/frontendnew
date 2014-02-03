Radium.CompanyController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  needs: ['users', 'accountSettings',  'tags', 'companies', 'countries', 'leadStatuses']
  leadStatuses: Ember.computed.alias 'controllers.leadStatuses'

  # FIXME: How do we determine this?
  isEditable: true

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

    maxStatus = if maxStatus == -1 then 0 else maxStatus

    @get('leadStatuses').objectAt(maxStatus).name
  ).property('contacts.[]')

  membersText: Ember.computed 'contacts.[]', ->
    "View all #{@get('contacts.length')} contacts."

  truncatedContacts: ( ->
    @get('contacts').toArray().sort((left, right) ->
      Ember.compare(left.get('name'), right.get('name'))).slice(0, 3)
  ).property('contacts.[]', 'model')

  hasMoreContacts: ( ->
    contacts = @get('contacts.length')

    return unless contacts

    contacts > @get('truncatedContacts.length')
  ).property('contacts.[]', 'truncatedContacts')
