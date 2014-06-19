require 'lib/radium/aggregate_array_proxy'

Radium.AddressBookArrayProxy = Radium.AggregateArrayProxy.extend Ember.DeferredMixin,
  selectedFilter: null
  additionalFilter: null
  currentuser: null
  isLoaded: false
  searchText: null
  assignedUser: null

  load: ->
    return if @get('isLoaded')

    @clear()

    Radium.Contact.find({}).then (contacts) =>
      @add contacts
      Radium.Company.find({}).then (companies) =>
        @add companies
        Radium.Tag.find({}).then (tags) =>
          @set 'isLoaded', true
          @add tags
          @set 'selectedFilter', 'all'
          @resolve this

  clear: ->
    @set 'isLoaded', false
    @set 'content', []
    @set 'additionalFilter', null

  contacts: Ember.computed 'content.[]', ->
    @get("content").filterBy "constructor", Radium.Contact

  arrangedContent: Ember.computed 'content.[]', 'selectedFilter', 'searchText', 'additionalFilter', ->
    content = @get('content')
    return unless content

    return Ember.A() if !@get('isLoaded') || !@get('selectedFilter')

    content = content.filter @filterFunction.bind(this)

    if searchText = @get('searchText')
      unless @get('selectedResource')
        content = content.filter (item) ->
                      name = item.get('name') || item.get('displayName')
                      return false unless name
                      ~name.toLowerCase().indexOf(searchText.toLowerCase())

    if @get('additionalFilter')
      content = content.filter @furtherFilter.bind(this)

    content.setEach 'isChecked', false

    unless @get('selectedFilter') == 'private'
      content = content.reject (item) =>
                  item.constructor == Radium.Contact && item.get('isPersonal')

    # FIXME: how are we sorting?
    content.sort @sortResults.bind(this)

  sortResults: (left, right) ->
    Ember.compare left.get('name'), right.get('name')

  furtherFilter: (item) ->
    @["filter#{@get('additionalFilter').classify()}"](item)

  filterFunction: (item) ->
    @["filter#{@get('selectedFilter').classify()}"](item)

  filterPrivate: (item) ->
    item.constructor == Radium.Contact && item.get('isPersonal')

  filterTags: (item) ->
    item.constructor is Radium.Tag

  filterAssigned: (item) ->
    item.get('user') == @get('currentUser')

  filterAll: (item) ->
    item

  filterCompanies: (item) ->
    item.constructor is Radium.Company

  filterExclude: (item) ->
    ((item.constructor is Radium.Contact) && (item.get('status') == 'exclude'))

  filterLead: (item) ->
    ((item.constructor is Radium.Contact) && (item.get('status') == 'pipeline'))

  filterPersonal: (item) ->
    ((item.constructor is Radium.Contact) && (item.get('status') == 'personal'))

  filterUsersContacts: (item) ->
    Ember.assert "An assigned user must be set to filter in the addressbook", @get('assignedUser')
    ((item.constructor is Radium.Contact) && (item.get('user') == @get('assignedUser')))

  filterResource: (item) ->
    selectedResource = @get('selectedResource')

    if selectedResource instanceof Radium.Company
      item.get('company') is selectedResource
    else if selectedResource instanceof Radium.ContactImportJob
      item.get('contactImportJob') is selectedResource
    else
      item.get('tags').contains selectedResource if item.get('tags')

  filterPeople: (item) ->
    item.constructor is Radium.Contact

  filterInitital: (item) ->
    @get('content').filter((item) ->
      item.constructor == Radium.Contact
    ).sort(@sortResults.bind(this))
    .slice(0, 10)
