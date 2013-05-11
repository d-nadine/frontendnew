Radium.DealsNewController = Radium.ObjectController.extend
  needs: ['contacts','users', 'dealStatuses', 'dealSources']
  contacts: Ember.computed.alias 'controllers.contacts'
  checklistItems: Ember.computed.alias 'checklist.checklistItems'
  statuses: Ember.computed.alias('controllers.dealStatuses.inOrder')
  newItemDescription: ''
  newItemWeight: null
  newItemFinished: true
  hasContact: Ember.computed.bool 'contact'

  contactsWithCompany: ( ->
    @get('contacts').map (contact) ->
      Ember.Object.create
        name: "#{contact.get('name')} (#{contact.get('company.name')})"
        contact: contact
  ).property('contacts.[]')

  statusesDidChange: ( ->
    return unless @get('statuses.length')
    return if @get('status')

    @set('status', @get('statuses.firstObject'))
  ).observes('statuses.[]')

  saveAsDraft: ->
    @set 'isPublished', false
    @submit()

  publish: ->
    @set 'isPublished', true
    @submit()

  submit: ->
    @set 'isSubmitted', true
    return unless @get('isValid')

    deal = @get('model').create()

    deal.one 'didCreate', =>
      @transitionToRoute 'deal', deal

    @get('store').commit()
