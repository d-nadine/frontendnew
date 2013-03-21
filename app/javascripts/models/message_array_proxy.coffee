require 'lib/radium/aggregate_array_proxy'

Radium.MessageArrayProxy = Radium.AggregateArrayProxy.extend
  init: ->
    @_super()

    @add Radium.Email.all()
    @add Radium.Discussion.all()

  folder: 'inbox'
  currentUser: null

  arrangedContent: (->
    content = @get('content')
    return unless content

    content.filter @filterFunction.bind(this)
  ).property('content.[]', 'folder')

  filterFunction: (item) ->
    @["filter#{@get('folder').classify()}"](item)

  filterInbox: (item) ->
    item.get('sender') isnt @get('currentUser')

  filterSent: (item) ->
    item.get('sender') is @get('currentUser')

  filterDiscussions: (item) ->
    item instanceof Radium.Discussion

  filterEmails: (item) ->
    item instanceof Radium.Email

