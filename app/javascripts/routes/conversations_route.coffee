require 'mixins/controllers/track_contact_mixin'

Radium.ConversationsRoute = Radium.Route.extend Radium.TrackContactMixin,
  queryParams:
    user:
      refreshModel: true

  beforeModel: (transition) ->
    type = transition.params.conversations.type
    controller = @controllerFor 'conversations'

    controller.send 'reset'

    controller.set 'allChecked', false
    controller.get('content').setEach 'isChecked', false
    controller.set 'searchText', ''

    controller.set 'isLoading', true
    controller.set 'totalsLoading', true
    controller.set('conversationType', type)

    unless ['team', 'shared'].contains transition.params.conversations.type
      controller.set 'user', null

      delete transition.params.conversations.user

    type

  model: (params) ->
    args =
      name: params.type
      pageSize: 5

    if user = params.user
      args.user = user

    Radium.Email.find(args)

  setupController: (controller, model) ->
    @_super.apply this, arguments
    controller.set 'model', model.toArray()
    controller.set 'isLoading', false
    controller.send 'updateTotals'

    return if controller.get 'allPagesLoaded'

    for i in [0...4]
      controller.send 'showMore'

  deactivate: ->
    @_super.apply this, arguments
    controller = @controllerFor 'conversations'
    return unless controller.get('hasCheckedContent')

    controller.get('checkedContent').forEach (email) ->
      email.set 'isChecked', false
