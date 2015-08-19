Radium.ListstatusEditorComponent = Ember.Component.extend
  actions:
    deleteListStatus: (listStatus) ->
      name = listStatus.get('name')
      list = listStatus.get('list')

      if list.get('listStatuses.length') <= 2
        return @flashMessenger.error "You must have at least 2 list statuses."

      listStatus.delete().then( =>
        @flashMessenger.success "List Status #{name} has been deleted."
      ).catch ->
        list.reload()

  tagName: 'li'
