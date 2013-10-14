Radium.ApplicationRoute = Radium.Route.extend
  actions:
    logOut: ->
      Radium.get('authManager').logOut(@get('store._adapter.url'))

    toggleNotifications: ->
      if @get('router.openDrawer') == name
        @send 'closeDrawer'
      else
        $('body').addClass 'drawer-open'

        @render 'notifications',
          outlet: 'drawer'
          into: 'application'

        @set 'router.openDrawer', name
        Radium.set 'notifyCount', 0
        Ember.run.later =>
          notifications = @controllerFor('notifications').get('model')

          return unless notifications.get('length')

          notifications.filter((notification) ->
            !notification.get('read')
          )
          .forEach (notification) =>
            notification.set('read', true)

          @get('store').commit()
        , 200

    toggleDrawer: (name) ->
      if @get('router.openDrawer') == name
        $('body').removeClass 'drawer-open'
        @send 'closeDrawer'
      else
        route = name.split('/')[0]

        Ember.assert("Could not find a matching controller for: #{name}", route)

        $('body').addClass 'drawer-open'

        @render name,
          outlet: 'drawer'
          into: 'application'
          controller: @controllerFor(route)

        @set 'router.openDrawer', name

    closeDrawer: ->
      @disconnectOutlet(
        outlet: 'drawer'
        parentView: 'application'
      )

      @set 'router.openDrawer', null
      $('body').removeClass 'drawer-open'

    closeModal: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    back: ->
      history = @get('router.history')

      if history.length > 2
        history.pop()
        lastPage = history.pop()
      else if history.length == 2
        lastPage = history.shift()
        history.clear()
      else
        return

      if lastPage[1]
        @transitionTo lastPage[0], lastPage[1]
      else
        @transitionTo lastPage[0]

    flashMessage: (options) ->
      controller = @controllerFor 'flash'
      content = if !options.message
                  "Settings saved!"
                else if options.message && typeof options.message == "string"
                  options.message
                else
                  null

      model = if content then null else options.message

      controller.setProperties
        type: options.type ? null
        message: content
        model: model

      @render 'flash',
        into: 'application'
        outlet: 'flash'
        controller: controller

    flashSuccess: (message) ->
      @send 'flashMessage',
        type: 'alert-success'
        message: message

    flashError: (error) ->
      @send 'flashMessage',
        type: 'alert-error'
        message: error

    confirmTaskDeletion: (task) ->
      controller = @controllerFor("#{task.humanize()}DeletionConfirmation")
      controller.set 'model', task

      @render "#{task.humanize()}/deletion_confirmation",
        into: 'application'
        outlet: 'modal'

  activate: ->
    notificationPoller = Radium.NotificationsPoller.create()
    Radium.set('notificationPoller', notificationPoller)
    notificationPoller.start()

    unless @controllerFor('currentUser').get('initialMailImported')
      initialImporter = Radium.InitialImportPoller.create
        currentUser: @controllerFor('currentUser').get('model')

      initialImporter.start()

  deactivate: ->
    Radium.get('notificationPoller').stop()
    if model = @controllerFor('messages').get('model')
      model.stop()

  model: ->
    Radium.Deal.find({})

  setupController: (controller, deals) ->
    messages = Radium.MessageArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')
      content: Ember.A()
    @controllerFor('messages').set 'model', messages
    messages.onPoll()
    messages.start()

    @controllerFor('subscriptionPlans').set 'model', Radium.SubscriptionPlan.find()
    @controllerFor('notifications').set 'model', Radium.Notification.all()
    @controllerFor('users').set 'model', Radium.User.find()
    @controllerFor('contacts').set 'model', Radium.Contact.find()
    @controllerFor('tags').set 'model', Radium.Tag.find()
    @controllerFor('companies').set 'model', Radium.Company.find()

    # FIXME: Where are we getting the county list from
    @controllerFor('countries').set 'model', Ember.A(['USA', 'Canada'])

    @controllerFor('clock').set 'model', Ember.DateTime.create()
