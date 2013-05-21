require 'lib/radium/aggregate_array_proxy'

Radium.AddressBookArrayProxy = Radium.AggregateArrayProxy.extend Ember.DeferredMixin,
  selectedFilter: null
  currentuser: null
  isloaded: false
  searchText: null

  load: ->
    return if @get('isLoaded')

    @clear()

    Radium.Contact.all().then (contacts) =>
      @add contacts
      Radium.Company.all().then (companies) =>
        @add companies
        Radium.Tag.all().then (tags) =>
          @set 'isLoaded', true
          @add tags
          @set 'selectedFilter', 'people'
          @resolve this

  clear: ->
    @set 'isLoaded', false
    @set 'content', []

  arrangedContent: (->
    content = @get('content')
    return unless content

    return Ember.A() if !@get('isLoaded') || !@get('selectedFilter')

    content = content.filter @filterFunction.bind(this)

    if searchText = @get('searchText')
      content = content.filter (item) ->
                    ~item.get('name').toLowerCase().indexOf(searchText.toLowerCase())

    content.setEach 'isChecked', false

    content

    # FIXME: how are we sorting?
    content.sort @sortResults.bind(this)

  ).property('content.[]', 'selectedFilter', 'searchText')

  sortResults: (left, right) ->
    Ember.compare left.get('name'), right.get('name')

  filterFunction: (item) ->
    @["filter#{@get('selectedFilter').classify()}"](item)

  filterTags: (item) ->
    item.constructor is Radium.Tag

  filterAssigned: (item) ->
    item.get('user') == @get('currentuser')

  filterAll: (item) ->
    item

  filterCompanies: (item) ->
    item.constructor is Radium.Company

  filterExisting: (item) ->
    ((item.constructor is Radium.Contact) && (item.get('status') == 'existing'))

  filterExclude: (item) ->
    ((item.constructor is Radium.Contact) && (item.get('status') == 'exclude'))

  filterLead: (item) ->
    ((item.constructor is Radium.Contact) && (item.get('status') == 'lead'))

  filterPeople: (item) ->
    item.constructor is Radium.Contact

  filterInitital: (item) ->
    @get('content').filter((item) ->
      item.constructor == Radium.Contact
    ).sort(@sortResults.bind(this))
    .slice(0, 10)
