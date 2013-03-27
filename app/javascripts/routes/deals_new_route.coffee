Radium.DealsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    checklistItems = controller.get('checklist.checklistItems')
    if checklistItems.length
      controller.set 'selectedCheckboxItem', checklistItems.objectAt(0)

  setup: (context) ->
    @transitioned = false
    @redirect context
    return false  if @transitioned
    controller = @controllerFor(@routeName)

    @controller = controller if controller

    if @setupControllers
      Ember.deprecate "Ember.Route.setupControllers is deprecated. Please use Ember.Route.setupController(controller, model) instead."
      @setupControllers controller, context
    else
      @setupController controller, context
    if @renderTemplates
      Ember.deprecate "Ember.Route.renderTemplates is deprecated. Please use Ember.Route.renderTemplate(controller, model) instead."
      @renderTemplates context
    else
      @renderTemplate controller, context
