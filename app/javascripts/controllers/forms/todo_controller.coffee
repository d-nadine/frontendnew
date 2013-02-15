Autocomplete =
  lookup: (term) ->
    @contacts().find (contact) ->
      contact.get('name') is term

  contacts: -> Radium.Contact.all()

Radium.FormsTodoController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users']
  users: Ember.computed.alias('controllers.users')

  submit: ->
    @set 'isSubmitted', true

  justAdded: (->
    @get('content.justAdded') == true
  ).property('content.justAdded')

  showOptions: Ember.computed.alias('isNew')

  showComments: (->
    return false if @get('justAdded')
    @get 'hasComments'
  ).property('justAdded', 'comments.length')

  showSuccess: Ember.computed.alias('justAdded')

  isEditable: (->
    return false if @get('justAdded')
    @get('content.isEditable') != false
  ).property('content.isEditable')

  isExpandable: (->
    return false if @get('justAdded')
    !@get('isNew') && !@get('isFinished')
  ).property('isNew', 'isFinished')

  isExpandableDidChange: (->
    if !@get('isExpandable') then @set('isExpanded', false)
  ).observes('isExpandable')

  isDisabled: (->
    return true if @get('justAdded')
    @get('content.isEditable') is false
  ).property('isEditable')

  showCallBox: (->
    @get('isCall') && !@get('isNew')
  ).property('isCall', 'isNew')

  toggleExpanded: -> @toggleProperty 'isExpanded'

  expand: ->
    return unless @get('isExpandable')
    @toggleProperty 'isExpanded'

  hasComments: Radium.computed.isPresent('comments')
