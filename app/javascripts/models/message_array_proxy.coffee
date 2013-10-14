require 'lib/radium/aggregate_array_proxy'
require 'mixins/controllers/poller_mixin'

Radium.MessageArrayProxy = Radium.AggregateArrayProxy.extend Radium.PollerMixin,
  folder: 'inbox'
  currentuser: null
  isloaded: false
  totalRecords: 0
  initialSet: false

  onPoll: ->
    return unless @get('initialSet')
    Radium.Email.find(user_id: @get('currentUser.id'), page: 1).then (emails) =>
      newEmails = @delta(emails)

      return unless newEmails.length

      console.log "#{newEmails.length} found"

      @add(newEmails)

      meta = emails.store.typeMapFor(Radium.Email).metadata

      @set('totalRecords', meta.totalRecords)

    Radium.Discussion.find({}).then (discussions) =>
      newDiscussions = @delta(discussions)

      return unless discussions.length

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
