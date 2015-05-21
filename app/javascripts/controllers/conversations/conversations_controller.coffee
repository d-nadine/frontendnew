Radium.ConversationsController = Radium.ArrayController.extend Radium.CheckableMixin,
  Radium.ShowMetalessMoreMixin,
  Radium.ConversationsColumnsConfig,
  Radium.TrackContactMixin,
  actions:
    completeAssignTo: (model, user) ->
      changed = @filter (m) =>
                  return false if @get('isIncoming') && user.get('id') == @get('currentUser.id')
                  return false if @get('user') == user.get('id')
                  m.get('model.sender.user') == user


      @send 'updateTotals'

      return unless !!changed.length

      Ember.run this, 'removeObjects', changed

      ele = Ember.$("[user-data-id=#{user.get('id')}]")

      return unless !!ele.length

      ele.addClass('blink').addClass('active')

      false

    showUserRecords: (user, query) ->
      @transitionToRoute 'conversations', query, queryParams: user: user.get('id')

      false

    ignoreDomain: (contact) ->
      domain = "#{contact.get('domain')}"

      excludedDomain = Radium.ExcludedDomain.createRecord
                         domain: domain

      excludedDomain.save(this)

      models = @filter (c) -> c.get('model.sender.primaryEmail.value').indexOf(domain) > 0

      @removeObjects models

      false

    updateConversation: (action, controller, contact) ->
      if action == "track"
        return @send "track", contact
      else if action == "ignore"
        property = "ignored"
        value = true
      else if action == "archive"
        property = "archived"
        value = true
      else if action == "stopIgnoring"
        property = "ignored"
        value = false
      else if action == "stopArchiving"
        property = "archived"
        value = false

      contact.set property, value

      self = this

      contact.save(this).then (result) ->
        contact.updateLocalProperty property, value
        self.removeObject controller.get('model')
        self.send 'updateTotals'

      false

    trackAll: ->
      self = this
      ignored = not @get('isIgnored')

      bulkActionDetail =
        actionFunc: (item) ->
          contact = item.get('contact')
          self.send "track", contact
          return contact
        endFunc: (item) ->
          contact = item.get('contact')
          contact.updateLocalProperty('isPublic', true)
          self.send 'flashSuccess', "The selected contacts are now tracked."

      @completeAction(bulkActionDetail)
      false

    updateTotals: ->
      Radium.ConversationsTotals.find({}).then (results) =>
        totals = results.get('firstObject')

        @set 'incoming', totals.get('incoming')
        @set 'waiting', totals.get('waiting')
        @set 'later', totals.get('later')

        @set 'allUsersTotals', totals.get('allUsersTotals')

        @set 'usersTotals', totals.get('usersTotals')
        @set 'sharedTotals', totals.get('sharedTotals')

        @set 'totalsLoading', false

      false

    checkAll: ->
      content = @get('content')

      content.setEach 'isChecked', !@get('hasCheckedContent')
      false

    emailAll: ->
      unless @get('hasCheckedContent')
        return @transitionToRoute "emails.new", "inbox", queryParams: mode: 'single', from_people: false

      contacts = @get('checkedContent').map (item) =>
        index = @get('content').indexOf item
        contact = @controllerAt(index).get('contact')
        Ember.Object.create
          id: contact.get('id')
          type: 'contact'
          _personContact: contact
          person: contact
          name: contact.get('name')
          email: contact.get('email')
          avatarKey: contact.get('avatarKey')
          displayName: contact.get('displayName')
          source: contact.get('source')

      emailForm = Radium.EmailForm.create()
      emailForm.reset()

      emailForm.set 'to', contacts

      @get('emailsNewController').set 'bulkForm', emailForm

      @transitionToRoute 'emails.new', "inbox", queryParams: mode: 'bulk', from_people: false

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
        actionFunc: (item) ->
          contact = item.get('contact')
          contact.set 'ignored', ignored
          return contact
        endFunc: (item) ->
          self.send 'flashSuccess', message
          item.get('contact').updateLocalProperty('ignored', ignored)
          self.removeObject item
          self.send 'updateTotals'

      @completeAction(bulkActionDetail)
      false

    archiveAll: ->
      self = this
      archived = not @get('isArchived')

      message = if archived
                  "The selected contacts mail is now archived."
                else
                  "The selected contacts mail is no longer archived."

      bulkActionDetail =
        actionFunc: (item) ->
          contact = item.get('contact')
          contact.set 'archived', archived
          return contact
        endFunc: (item) ->
          self.send 'flashSuccess', message
          item.get('contact').updateLocalProperty('archived', archived)
          self.removeObject item
          self.send 'updateTotals'

      @completeAction(bulkActionDetail)
      false

  completeAction: (bulkActionDetail) ->
    @completeBulkAction(bulkActionDetail).then((successFunc) ->
      successFunc()
    ).catch (error) ->
      Ember.Logger.error error

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
            resolve bulkActionDetail.endFunc.bind self, controller
            self.set 'allChecked', false

          if not item.get('isDirty')
            finish()

          item.save(this).then (result) ->
            finish()

  queryParams: ['user']

  team: Ember.computed 'currentUser', 'users.[]', ->
    currentUser = @get('currentUser')

    @get('users').reject (user) -> user == currentUser

  sharedInboxes: Ember.computed 'currentUser', 'team.[]', ->
    team = @get('team')

    team.reject (user) -> not user.get('shareInbox')

  needs: ['users', 'emailsNew']

  emailsNewController: Ember.computed.oneWay 'controllers.emailsNew'

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
  user: null
  allPagesLoaded: false

  users: Ember.computed.alias 'controllers.users'

  conversationsRoute: Ember.computed 'container', ->
    @container.lookup("route:conversations")

  modelQuery: (page, pageSize) ->
    args =
      name: @get('conversationType')
      page: page
      pageSize: pageSize

     if user = @get('user')
       args.user = user

    Radium.Email.find(args)
