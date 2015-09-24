Radium.DealSidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  actions:
    setPrimaryContact: (contact) ->
      unless contact
        @send 'flashError', 'You have not selected a contact'
        return false

      @set('deal.contact', contact)

      @get('deal').save().then (result) =>
        @send 'flashSuccess', "#{contact.get('displayName')} is now the primary contact."

      false

    afterSaveDeal: ->
      p arguments

      false

    confirmDeletion: ->
      @set "showDeleteConfirmation", true

      false

  classNameBindings: [':form']

  # UPGRADE: replace with inject
  users: Ember.computed ->
    @container.lookup('controller:users')

  contactValidations: ['required']
