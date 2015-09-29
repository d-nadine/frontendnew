Radium.ApplicationRoute = Radium.Route.extend
  actions:
    willTransition: (transition) ->
      if @get('currentUser').get('subscriptionInvalid')
        return true if transition.targetName in ["settings.billing", "settings.company"]

        @send 'flashError', 'You can only access the settings page unless you upgrade your plan.'
        transition.abort()
        return

      true

    error: (error, transition, route) ->
      Ember.Logger.error "In the error route handler in route #{route.constructor} and #{transition.targetName} and error #{error}"
      Ember.Logger.error error

    logOut: ->
      Radium.get('authManager').logOut(@get('store._adapter.url'))

    deleteTask: (model) ->
      msg = "#{model.humanize().capitalize()} has been deleted"

      model.delete()

      @send 'flashSuccess', msg

    toggleNotifications: ->
      controller = @controllerFor('application')

      if controller.get('showNotifications')
        controller.set('showNotifications', false)
      else
        @EventBus.publish('closeDrawers')
        controller.set('showNotifications', true)

        controller.set 'notificationCount', 0

        Ember.run.later =>
          notificationsController = @controllerFor 'notifications'

          notifications = notificationsController.get('model')

          return unless notifications.get('length')

          notifications.filter((notification) ->
            !notification.get('read')
          )
          .forEach (notification) ->
            notification.set('read', true)

          @get('store').commit()
        , 200

      false

    notificationDelete: (reference) ->
      notifications =  Radium.Notification.all().filter (notification) ->
        notification.get('reference') == reference

      return unless notifications.get('length')

      notifications.forEach (notification) ->
        notification.deleteRecord()

    toggleSidebar: ->
      @toggleProperty('controller.isSidebarVisible')

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
      ele = $("#{container} #{modelSelector}".trim())

      unless ele.length
        callback()
      else
        ele.animate {left: "-120%", height: 0}, duration, callback

  activate: ->
    @controllerFor('notifications').start()
    @controllerFor('messages').start()

  deactivate: ->
    @controllerFor('notifications').stop()
    @controllerFor('messages').stop()

  model: ->
    Ember.RSVP.hash
      templates: Radium.Template.find({})

  afterModel: ->
    if @get('currentUser').get('subscriptionInvalid')
      @replaceWith 'settings.billing'

  setupController: (controller, lookups) ->
    @container.lookup('templates:service').set 'templates', lookups.templates

    @controllerFor('subscriptionPlans').set 'model', Radium.SubscriptionPlan.find()
    @controllerFor('notifications').set 'model', Radium.Notification.all()
    @controllerFor('users').set 'model', Radium.User.find()
    @controllerFor('contactStatuses').set 'model', Radium.ContactStatus.find({})

    contactsController = @controllerFor('contacts')
    @controllerFor('lists').set 'lists', Radium.List.find()
    @controllerFor('companies').set 'model', Radium.Company.find()

    # FIXME: Where are we getting the county list from
    @controllerFor('countries').set 'model', Ember.A(['USA', 'Canada'])

    @controllerFor('clock').set 'model', Ember.DateTime.create()
    @controllerFor('settingsCustomFields').set 'model', Radium.CustomField.find({})
