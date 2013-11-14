Radium.ExternalcontactsController = Radium.ArrayController.extend
  needs: ['addressbook']
  page: 1
  allPagesLoaded: false

  categories: Ember.computed.alias 'controllers.addressbook.categories'

  actions:
    showMore: ->
      return if @get('allPagesLoaded')

      @set('isLoading', true)

      page = @get('page') + 1

      Radium.ExternalContact.find(user_id: @get('currentUser.id'), page: page).then (contacts) =>
        content = @get('content')

        meta = contacts.store.typeMapFor(Radium.ExternalContact).metadata
        @set('totalRecords', meta.totalRecords)
        @set('allPagesLoaded', meta.isLastPage)

        unless contacts.get('length')
          @set('isLoading', false)
          if page > meta.totalPages
            @set 'allPagesLoaded', true
          return

        ids = content.map (contact) -> contact.get('id')

        contacts.toArray().forEach (contact) ->
          content.pushObject(contact) unless ids.contains(contact.get('id'))
          ids.push contact.get('id')

        @set('isLoading', false)
