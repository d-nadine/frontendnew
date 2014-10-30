Radium.ConversationsController = Radium.ArrayController.extend Radium.CheckableMixin,
  actions:
    updateTotals: ->
      Radium.ConversationsTotals.find({}).then (results) =>
        totals = results.get('firstObject')

        @set 'incoming', totals.get('incoming')
        @set 'waiting', totals.get('waiting')
        @set 'later', totals.get('later')
        @set 'totalsLoading', false

    checkAll: ->
      content = @get('content')

      content.setEach 'isChecked', !@get('hasCheckedContent')

    trackAll: ->
      self = this

      bulkActionDetail =
        action: 'didUpdate'
        actionFunc: (item) ->
          contact = item.get('contact')
          contact.track()
          return contact
        endFunc: ->
          self.send 'flashSuccess', "You are now tracking the selected contacts"

      @completeBulkAction(bulkActionDetail).then (result) ->
        result()

    archiveAll: ->
      self = this
      bulkActionDetail =
        action: 'didUpdate'
        actionFunc: (item) ->
          email = item.get('model')
          email.set 'archived', true
          return email
        endFunc: ->
          self.send 'flashSuccess', 'You have archived all the selected emails'
          self.container.lookup('route:conversations').refresh()

      @completeBulkAction(bulkActionDetail).then (result) ->
        result()

    deleteAll: ->
      self = this
      bulkActionDetail =
        action: 'didDelete'
        actionFunc: (item) ->
          email = item.get('model')
          email.deleteRecord()
          return email
        endFunc: ->
          self.send 'flashSuccess', 'You have deleted all the deleted emails'
          self.container.lookup('route:conversations').refresh()

      @completeBulkAction(bulkActionDetail).then (result) ->
        result()

  completeBulkAction: (bulkActionDetail) ->
    self = this
    content = @get('content')

    return new Ember.RSVP.Promise (resolve, reject) ->
      unless self.get('hasCheckedContent')
        return resolve(-> self.send 'flashError', 'You have not selected any content.')

      checkedContent = self.get('checkedContent')

      checkedContent.forEach (email) ->
        index = content.indexOf(email)
        controller = self.controllerAt(index)
        item = bulkActionDetail.actionFunc(controller)

        if email == checkedContent.get('lastObject')
          finish = ->
            checkedContent.setEach 'isChecked', false
            resolve bulkActionDetail.endFunc

          if not item.get('isDirty')
            finish()

          item.one bulkActionDetail.action, ->
            finish()

      self.get('store').commit()

  needs: ['users']
  itemController: 'conversationsItem'
  conversationType: null

  isIncoming: Ember.computed.equal "conversationType", "incoming"
  isWaiting: Ember.computed.equal "conversationType", "waiting"
  isLater: Ember.computed.equal "conversationType", "later"
  isReplied: Ember.computed.equal "conversationType", "replied"
  isArchived: Ember.computed.equal "conversationType", "archived"
  isIgnored: Ember.computed.equal "conversationType", "ignored"

  users: Ember.computed.alias 'controllers.users'
