Radium.ContactSidebarComponent = Ember.Component.extend Radium.ScrollableMixin,
  actions:
    addTag: (tag) ->
      @sendAction "addTag", @get('contact'), tag

      false

    removeTag: (tag) ->
      @sendAction "removeTag", @get('contact'), tag

      false

    switchShared: ->
      return if @get('isSaving')

      @set 'isSaving', false

      contact = @get('contact')
      contact.toggleProperty('isPublic')

      contact.save().finally =>
        @set 'isSaving', false

    confirmDeletion: ->
      @sendAction "confirmDeletion"

      false

  classNameBindings: [':form']

  # UPGRADE: replace with inject
  contactStatuses: Ember.computed ->
    @container.lookup('controller:contactStatuses')

  companies: Ember.computed ->
    @container.lookup('controller:companies')

  users: Ember.computed ->
    @container.lookup('controller:users')

  leadSources: Ember.computed ->
    @container.lookup('controller:accountSettings').get('leadSources')

  shared: false
  isSaving: false
  condense: false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'shared', @get('contact.isLoaded')
