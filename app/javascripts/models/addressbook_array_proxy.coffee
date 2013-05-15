require 'lib/radium/aggregate_array_proxy'

Radium.AddressBookArrayProxy = Radium.AggregateArrayProxy.extend Ember.DeferredMixin,
  selectedFilter: null
  currentuser: null
  isloaded: false

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
          @set 'selectedFilter', 'initial'
          @resolve this

  clear: ->
    @set 'isLoaded', false
    @set 'content', []

  arrangedContent: (->
    content = @get('content')
    return unless content

    return Ember.A() if !@get('isLoaded') || !@get('selectedFilter')

    if @get('selectedFilter') == 'initial'
      return @filterInitital()

    content
  ).property('content.[]', 'selectedFilter')

  filterFunction: (item) ->
    @["filter#{@get('selectedFilter').classify()}"](item)

  filterInitital: (item) ->
    @get('content').filter((item) ->
      item.constructor == Radium.Contact
    ).sort((a, b) ->
      Ember.DateTime.compare(a.get('updatedAt'), b.get('updatedAt'))
    ).slice(0, 10)

