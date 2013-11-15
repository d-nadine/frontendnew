Radium.ExternalcontactsController = Radium.ArrayController.extend Radium.InfiniteScrollControllerMixin,
  needs: ['addressbook']
  page: 1
  allPagesLoaded: false
  pageSize: 20
  loadingType: Radium.ExternalContact

  categories: Ember.computed.alias 'controllers.addressbook.categories'

  actions:
    promote: (model, state) ->
      #do stuff

    reset: ->
      @set('page', 1)

  modelQuery: ->
    Radium.ExternalContact.find(@queryParams())

  queryParams: ->
    pageSize = @get('pageSize')
    userId = @get('currentUser.id')
    page = @get('page')

    page: page
    page_size: pageSize
    user_id: userId
