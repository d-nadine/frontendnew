Radium.EmailsThreadController = Radium.ArrayController.extend
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

  needs: ['messages']
  selectedContent: Ember.computed.oneWay 'controllers.messages.selectedContent'
  pageSize: 7
  hasReplies: true

  setup: (->
    @set 'allPagesLoaded', false
  ).on 'init'