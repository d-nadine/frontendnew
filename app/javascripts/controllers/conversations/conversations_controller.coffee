Radium.ConversationsController = Radium.ArrayController.extend Radium.CheckableMixin,
  Radium.ShowMetalessMoreMixin,
  Radium.ConversationsColumnsConfig,
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
      false

    emailAll: ->
      unless @get('hasCheckedContent')
        return @transitionToRoute "emails.new", "inbox", queryParams: mode: 'single', from_people: false

      contacts = @get('checkedContent').map (item) =>
        index = @get('content').indexOf item
        @controllerAt(index).get('contact')

      emailForm = @get('controllers.emailsNew.newEmail')

      emailForm.set 'to', contacts

      @transitionToRoute 'emails.new', "inbox", queryParams: mode: 'single'

    assignAll: (user) ->
      self = this

      bulkActionDetail =
        action: 'didUpdate'
        actionFunc: (item) ->
          contact = item.get('contact')
          contact.set 'user', user
          return contact
        endFunc: ->
          self.send 'flashSuccess', "The selected contacts have been assigned to #{user.get('displayName')}"

      @completeAction(bulkActionDetail)
      false

    ignoreAll: ->
      self = this
      ignored = not @get('isIgnored')

      message = if ignored
                  "The selected contacts mail is now ignored."
                else
                  "The selected contacts mail is no longer ignored."

      bulkActionDetail =
        action: 'didUpdate'
        actionFunc: (item) ->
          contact = item.get('contact')
          contact.set 'ignored', ignored
          return contact
        endFunc: ->
          self.send 'flashSuccess', message
          self.container.lookup('route:conversations').refresh()

      @completeAction(bulkActionDetail)
      false

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

      @completeAction(bulkActionDetail)
      false

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

      @completeAction(bulkActionDetail)
      false

  completeAction: (bulkActionDetail) ->
    @completeBulkAction(bulkActionDetail).then((successFunc) ->
      successFunc()
    ).catch (errorFunc) ->
      errorFunc()

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

          item.one 'becameInvalid', ->
            reject(-> self.send 'flashError', item)

          item.one 'becameError', ->
            reject(-> self.send 'flashError', "An error has occurred and the operation could not be completed.")

      self.get('store').commit()

  needs: ['users', 'emailsNew']
  itemController: 'conversationsItem'
  conversationType: null

  isIncoming: Ember.computed.equal "conversationType", "incoming"
  isWaiting: Ember.computed.equal "conversationType", "waiting"
  isLater: Ember.computed.equal "conversationType", "later"
  isReplied: Ember.computed.equal "conversationType", "replied"
  isArchived: Ember.computed.equal "conversationType", "archived"
  isIgnored: Ember.computed.equal "conversationType", "ignored"
  isContentLoaded: false

  page: 1
  pageSize: 10
  allPagesLoaded: false

  users: Ember.computed.alias 'controllers.users'

  conversationsRoute: Ember.computed 'container', ->
    @container.lookup("route:conversations")

  modelQuery: (page, pageSize) ->
    Radium.Email.find(name: @get('conversationType'), page: page, pageSize: pageSize)
