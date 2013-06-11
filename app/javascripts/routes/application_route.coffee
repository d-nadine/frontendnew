Radium.ApplicationRoute = Radium.Route.extend
  events:
    # Fired whenever the application enters
    # a new route
    didTransition: ->
      @send 'closeDrawer'

    toggleNotifications: ->
      if @get('router.openDrawer') == name
        @send 'closeDrawer'
      else
        $('body').addClass 'drawer-open'

        @render 'notifications',
          outlet: 'drawer'
          into: 'application'

        @set 'router.openDrawer', name

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
      @render 'nothing',
        into: 'application'
        outlet: 'drawer'

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

  model: ->
    Radium.Deal.find({})

  setupController: (controller, deals) ->
    @controllerFor('users').set 'model', Radium.User.find()
    @controllerFor('contacts').set 'model', Radium.Contact.find()
    @controllerFor('tags').set 'model', Radium.Tag.find()
    @controllerFor('companies').set 'model', Radium.Company.find()

    Radium.Email.find()
    Radium.Discussion.find()

    # FIXME: Where are we getting the county list from
    @controllerFor('countries').set 'model', Ember.A(['USA', 'Canada', 'Germany', 'UK'])

    @controllerFor('clock').set 'model', Ember.DateTime.create() 

  renderTemplate: ->
    @render()

    @render 'drawer_panel',
      into: 'application'
      outlet: 'drawerPanel'
