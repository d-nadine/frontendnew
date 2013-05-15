require 'lib/radium/aggregate_array_proxy'

Radium.AddressBookArrayProxy = Radium.AggregateArrayProxy.extend Ember.DeferredMixin,
  selectedFilter: null
  currentuser: null
  isloaded: false
  isInitialised: false
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
          @set 'selectedFilter', 'all'
          @resolve this

  clear: ->
    @set 'isLoaded', false
    @set 'content', []

  arrangedContent: (->
    content = @get('content')
    return unless content

    return Ember.A() if !@get('isLoaded') || !@get('selectedFilter')

    if @get('selectedFilter') == 'all' && !@get('isInitialised')
      @set 'isInitialised', true
      return @filterInitital()

    content = content.filter @filterFunction.bind(this)

    if searchText = @get('searchText')
      beginsWith = content.filter (item) ->
                    ~item.get('name').toLowerCase().indexOf(searchText.toLowerCase())

      return beginsWith

    content
  ).property('content.[]', 'selectedFilter', 'searchText')

  filterFunction: (item) ->
    @["filter#{@get('selectedFilter').classify()}"](item)

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

  filterInitital: (item) ->
    @get('content').filter((item) ->
      item.constructor == Radium.Contact
    ).sort((a, b) ->
      Ember.DateTime.compare(a.get('updatedAt'), b.get('updatedAt'))
    ).slice(0, 10)
