require 'routes/emails/base_show_route'

Radium.EmailsThreadRoute = Radium.ShowRouteBase.extend
  setupController: (controller, model) ->
    model.set 'isRead', true
    @store.commit()

    @controllerFor('messages').set 'selectedContent', model

    controller.set('currentPage', 1)

    controller.set 'isLoading', true

    controller.set 'model', Ember.A([model])

    replies = model.get('replies').slice().toArray()
      .reject((reply) -> reply.get('id') == model.get('id'))

    replies.forEach (reply) ->
      observer = ->
        return unless reply.get('isLoaded')

        reply.removeObserver 'isLoaded', observer
        controller.get('model').pushObject(reply)

        if controller.get('model.length') >= (replies.get('length') - 1) || controller.get('model.length') == 5
          controller.set 'isLoading', false

          Ember.run.next ->
            window.scrollTo(0,0)

      if reply.get('isLoaded')
        observer()
      else
        reply.addObserver 'isLoaded', observer
