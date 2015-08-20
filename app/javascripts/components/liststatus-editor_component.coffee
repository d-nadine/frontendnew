Radium.ListstatusEditorComponent = Ember.Component.extend
  actions:
    switchStatus: ->
      @set "isSaving", true

      listStatus = @get('listStatus')

      Ember.run.next =>
        statusType = if @get('isActive')
                       "active"
                     else
                       "inactive"

        listStatus.set('statusType', statusType)

        listStatus.save()

      false

    deleteListStatus: (listStatus) ->
      name = listStatus.get('name')
      list = listStatus.get('list')

      if list.get('listStatuses.length') <= 2
        return @flashMessenger.error "You must have at least 2 list statuses."

      listStatus.delete().then( =>
        @flashMessenger.success "List Status #{name} has been deleted."
      ).catch ->
        list.reload()

      false

  tagName: 'li'

  isActive: null
  isSaving: false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set 'isActive', @get('listStatus.isActive')
