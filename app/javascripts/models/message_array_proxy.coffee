require 'lib/radium/aggregate_array_proxy'
require 'mixins/controllers/poller_mixin'

Radium.MessageArrayProxy = Radium.AggregateArrayProxy.extend Radium.PollerMixin,
  folder: 'inbox'
  currentuser: null
  isloaded: false

  onPoll: ->
    Radium.Email.find({user_id: @get('currentUser.id')}).then (emails) =>
      newEmails = @delta(emails)

      if newEmails.length
        console.log "#{newEmails.length} found"
        @add(newEmails)
      Radium.Discussion.find({}).then (discussions) =>
        newDiscussions = @delta(emails)
        @add(newDiscussions) if newDiscussions.length

  delta: (records) ->
    delta = records.toArray().reject (record) =>
                @get('content').contains(record)

    delta

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

  filterUntracked: (item) ->
    item.get('isPersonal') is false
