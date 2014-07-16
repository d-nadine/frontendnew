Radium.ExternalcontactsController = Radium.ArrayController.extend
  actions:
    promote: (model, status) ->
      console.log 'I want to promote this', model, status
      promote = Radium.PromoteExternalContact.createRecord
                externalContact: model
                status: status

      addressBookController = @get('controllers.addressbook.model')

      promote.one 'didCreate', (result) =>
        @send "flashSuccess", "Contact created!"
        @get('content').removeObject(model)

      @get('store').commit()


###
Radium.ExternalcontactsController = Radium.ArrayController.extend Radium.InfiniteScrollControllerMixin,
  Radium.CheckableMixin,
  Radium.BulkActionControllerMixin,

  needs: ['addressbook']
  page: 0
  allPagesLoaded: false
  pageSize: 10
  loadingType: Radium.ExternalContact

  categories: Ember.computed.alias 'controllers.addressbook.categories'
  searchText: null

  actions:
    promote: (model, status) ->
      promote = Radium.PromoteExternalContact.createRecord
                externalContact: model
                status: status

      addressBookController = @get('controllers.addressbook.model')

      promote.one 'didCreate', (result) =>
        @send "flashSuccess", "Contact created!"
        @get('content').removeObject(model)

      @get('store').commit()

    deleteExternalContact: (model) ->
      @send 'animateDelete', model, =>
        name = model.get('displayName')

        model.deleteRecord()

        @get('store').commit()

        @send 'flashSuccess', "#{name} has been deleted."

    showMore: ->
      return false if @get('searchText.length')
      @_super.apply this, arguments
      false

    reset: ->
      @set('model', Ember.A())
      @set 'allPagesLoaded', false
      @set('page', 0)
      @send 'showMore'

  modelQuery: ->
    Radium.ExternalContact.find(@queryParams())

  queryParams: ->
    pageSize = @get('pageSize')
    userId = @get('currentUser.id')
    page = @get('page')

    if page < 1
      paget = 1

    page: page
    page_size: pageSize
    user_id: userId

  arrangedContent: Ember.computed 'content.[]', ->
    return unless @get('content.length')

    @get('content').filter (item) -> item.get('name.length') || item.get('email.length')

  isLoading: false

  searchTextDidChange: Ember.observer 'searchText', ->
    searchText = @get('searchText')

    unless searchText?.length
      @send 'reset'
      return

    return unless searchText?.length > 1

    @set('isLoading', true)

    Radium.AutocompleteItem.find(scopes: 'external_contact', term: searchText).then (results) =>
      unless results.get('length')
        @set('content', Ember.A())

      people = Ember.A(results.map (result) -> result.get('person'))

      @set('content', Ember.A())
      @set("content", people)
      @set('isLoading', false)
###
