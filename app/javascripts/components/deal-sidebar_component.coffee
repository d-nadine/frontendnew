Radium.DealSidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  actions:
    showContactDrawer: (resource) ->
      contact = if resource.constructor == Radium.Contact
                  resource
                else
                  resource.get('contact')

        @sendAction "showContactDrawer", contact

      false

    showCompanyDrawer: (deal) ->
      @sendAction "showCompanyDrawer", deal.get('company')

      false

    setPrimaryContact: (contact) ->
      unless contact
        @send 'flashError', 'You have not selected a contact'
        return false

      return unless [Radium.Contact, Radium.AutocompleteItem].contains(contact.constructor)

      contact = if contact.constructor == Radium.AutocompleteItem
                  contact.get('person')
                else
                  contact

      deal = @get('deal')

      deal.set('contact', contact)

      deal.save().then (result) =>
        @send 'flashSuccess', "#{contact.get('displayName')} is now the primary contact."

        @EventBus.publishModelUpdate deal

      false

    confirmDeletion: ->
      @set "showDeleteConfirmation", true

      false

  classNameBindings: [':form']

  # UPGRADE: replace with inject
  users: Ember.computed ->
    @container.lookup('controller:users')

  contactValidations: ['required']
