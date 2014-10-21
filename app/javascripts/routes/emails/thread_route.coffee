require 'routes/emails/base_show_route'

Radium.EmailsThreadRoute = Radium.ShowRouteBase.extend
  beforeModel: ->
    controller = @controllerFor('emailsThread')
    controller.set 'isLoading', true
    controller.set 'allPagesLoaded', false
    controller.set 'page', 1
    controller.set 'hasReplies', true
    controller.set 'initialised', false

  afterModel: (model, transition) ->
    model.set 'isTransitioning', true
    controller = @controllerFor('emailsThread')

    pageSize = controller.get('pageSize')
    query =
            name: 'reply_thread'
            emailId: model.get('id')
            page: 1
            page_size: pageSize

    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.Email.find(query).then((replies) ->
        model.set 'replies', replies
        resolve model
      ).catch ->
        controller.set 'false', true
        controller.set 'replies', []
        resolve(model)

  setupController: (controller, model) ->
    unless model.get('isRead')
      model.set('isRead', true)
      @store.commit()

    @controllerFor('messages').set 'selectedContent', model

    controller.set('currentPage', 1)

    controller.set 'isLoading', true

    replies = model.get('replies')

    unless replies.get('length')
      controller.set 'model', Ember.A([model])
      controller.set 'isLoading', false
      controller.set 'allPagesLoaded', true
      controller.set 'hasReplies', false
      controller.set 'page', 1
      model.set 'isTransitioning', false
      return

    models = Ember.A([model])

    replies.forEach (reply) ->
      observer = ->
        return unless reply.get('isLoaded')

        reply.removeObserver 'isLoaded', observer
        models.pushObject(reply)

        if models.get('length') >= replies.get('length') || models.get('length') == controller.get('pageSize')
          sorted = models.sort (a, b) ->
            Ember.DateTime.compare a.get('sentAt'), b.get('sentAt')

          controller.set 'model', sorted

          controller.set 'isLoading', false
          model.set 'isTransitioning', false

          controller.set('allPagesLoaded', controller.get('model.length') < controller.get('pageSize'))

      if reply.get('isLoaded')
        observer()
      else
        reply.addObserver 'isLoaded', observer
