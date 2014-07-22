Radium.ApplicationRoute = Radium.Route.extend
  actions:
    willTransition: (transition) ->
      if @controllerFor('currentUser').get('subscriptionInvalid')
        return true if transition.targetName == "settings.billing"

        @send 'flashError', 'You can only access the settings page unless you upgrade your plan.'
        transition.abort()
        return

      true

    error: (error, transition, route) ->
      console.log "In the error route handler in route #{route.constructor} and #{transition.targetName} and error #{error}"
      console.log(error.stack) if error.stack

    logOut: ->
      Radium.get('authManager').logOut(@get('store._adapter.url'))

    deleteTask: (model) ->
      msg = "#{model.humanize().capitalize()} has been deleted"

      model.deleteRecord()

      model.one 'becameError', (result) =>
        result.reset()
        @send 'flashError', result

      model.one 'becameError', (result) =>
        result.reset()
        @send 'flashError', result

      @get('store').commit()

      @send 'flashSuccess', msg

    toggleNotifications: ->
      controller = @controllerFor('notifications')

      if controller.get('drawerOpen')
        controller.set('drawerOpen', false)
        @send 'closeDrawer'
      else
        controller.set('drawerOpen', true)
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
          .forEach (notification) ->
            notification.set('read', true)

          @get('store').commit()
        , 200

    notificationDelete: (reference) ->
      notifications =  Radium.Notification.all().filter (notification) ->
        notification.get('reference') == reference

      return unless notifications.get('length')

      notifications.forEach (notification) ->
        notification.deleteRecord()

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

    toggleSidebar: ->
      @toggleProperty('controller.isSidebarVisible')

    closeDrawer: ->
      @disconnectOutlet(
        outlet: 'drawer'
        parentView: 'application'
      )

      @set 'router.openDrawer', null
      $('body').removeClass 'drawer-open'

    closeModal: ->
      @disconnectOutlet(
        outlet: 'modal'
        parentView: 'application'
      )

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

    # TODO: figure out a better way to do this
    animateDelete: (item, callback, container = '') ->
      duration = 600

      modelSelector = "[data-model='#{item.constructor}'][data-id='#{item.get('id')}']"
      $("#{container} #{modelSelector}".trim()).animate {left: "-120%", height: 0}, duration, callback

  activate: ->
    notificationPoller = Radium.NotificationsPoller.create()
    Radium.set('notificationPoller', notificationPoller)
    notificationPoller.start()

    @controllerFor('messages').start()

    unless @controllerFor('currentUser').get('initialMailImported')
      initialImporter = Radium.InitialImportPoller.create
        currentUser: @controllerFor('currentUser').get('model')
        controller: @controllerFor('messagesSidebar')

      initialImporter.start()

  deactivate: ->
    Radium.get('notificationPoller').stop()
    @controllerFor('messages').stop()

  model: ->
    Radium.Deal.find({})

  afterModel: ->
    if @controllerFor('currentUser').get('subscriptionInvalid')
      @transitionTo 'settings.billing'

  setupController: (controller, deals) ->
    @controllerFor('subscriptionPlans').set 'model', Radium.SubscriptionPlan.find()
    @controllerFor('notifications').set 'model', Radium.Notification.all()
    @controllerFor('users').set 'model', Radium.User.find()

    contactsController = @controllerFor('contacts')

    Radium.Contact.find({}).then (contacts) ->
      contactsController.set 'model', contacts
      contactsController.set 'isLoading', false

    @controllerFor('tags').set 'model', Radium.Tag.find()
    @controllerFor('companies').set 'model', Radium.Company.find()
    @controllerFor('deals').set 'model', Radium.Deal.find()

    # FIXME: Where are we getting the county list from
    @controllerFor('countries').set 'model', Ember.A(['USA', 'Canada'])

    @controllerFor('clock').set 'model', Ember.DateTime.create()
