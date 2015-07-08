Radium.ContactSidebarComponent = Ember.Component.extend
  actions:
    addTag: (tag) ->
      @sendAction "addTag", tag

      false

    removeTag: (tag) ->
      @sendAction "removeTag", tag

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

  shared: false
  isSaving: false
  condense: false

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'shared', @get('contact.isLoaded')
