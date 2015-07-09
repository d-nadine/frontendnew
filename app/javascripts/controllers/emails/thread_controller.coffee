require "mixins/save_contact_actions"
require "mixins/persist_tags_mixin"

Radium.EmailsThreadController = Radium.ArrayController.extend Radium.PersistTagsMixin,
  Radium.SaveContactActions,
  Radium.AttachedFilesMixin,
  actions:
    showMore: ->
      @set('isLoading', true)

      page = (@get('page') || 1) + 1

      @set('page', page)

      query =
        name: 'reply_thread'
        emailId: @get('selectedContent.id')
        page: @get('page')
        page_size: @get('pageSize')

      Radium.Email.find(query).then (records) =>
        content = @get('content')

        unless records.get('length')
          @set('isLoading', false)
          @set 'allPagesLoaded', true
          return

        ids = content.mapProperty('id')

        records.toArray().reverse().forEach (record) ->
          content.insertAt(0, record) unless ids.contains(record.get('id'))
          ids.push record.get('id')

        @set('isLoading', false)

  needs: ['messages', 'users', 'accountSettings']

  users: Ember.computed.oneWay 'controllers.users'
  leadSources: Ember.computed.oneWay 'controllers.accountSettings.leadSources'

  customFields: Ember.A()

  selectedContent: Ember.computed.oneWay 'controllers.messages.selectedContent'
  pageSize: 7
  hasReplies: true

  firstSender: Ember.computed.oneWay 'model.firstObject.sender', ->
    @get('model.firstObject.sender')

  senderIsContact: Ember.computed 'firstSender', ->
    @get('firstSender') instanceof Radium.Contact

  tagNames: Ember.computed.oneWay 'firstSender.tagNames'

  attachments: Ember.computed.oneWay 'firstSender.attachments'

  setup: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'allPagesLoaded', false
    @set 'intialised', false
