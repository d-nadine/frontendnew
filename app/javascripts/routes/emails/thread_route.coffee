require 'routes/emails/base_show_route'

Radium.EmailsThreadRoute = Radium.ShowRouteBase.extend
  setupController: (controller, model) ->
    model.set 'isRead', true
    @store.commit()

    @controllerFor('messages').set 'selectedContent', model

    controller.set 'isLoading', true

    controller.set 'model', Ember.A([model])

    model.get('replies').slice().toArray()
      .reject((reply) -> reply.get('id') == model.get('id'))
      .forEach (reply) ->
        observer = ->
          return unless reply.get('isLoaded')

          reply.removeObserver 'isLoaded', observer
          controller.get('model').pushObject(reply)

          if controller.get('model.length') == model.get('replies.length') || controller.get('model.length') == 5
            controller.set 'isLoading', false

            Ember.run.next ->
              window.scrollTo(0,0)

        if reply.get('isLoaded')
          observer()
        else
          reply.addObserver 'isLoaded', observer
