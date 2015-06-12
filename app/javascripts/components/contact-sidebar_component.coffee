Radium.ContactSidebarComponent = Ember.Component.extend
  actions:
    switchShared: ->
      return if @get('isSaving')

      @set 'isSaving', false

      contact = @get('contact')
      contact.toggleProperty('isPublic')

      contact.save().finally =>
        @set 'isSaving', false

  classNameBindings: [':form']

  shared: false
  isSaving: false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'shared', @get('contact.isLoaded')