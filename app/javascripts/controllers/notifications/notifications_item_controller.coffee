Radium.NotificationsItemController = Radium.ObjectController.extend
  actions:
    deleteNotification: ->
      model = if @get('model') instanceof Radium.ObjectController
                @get('model.model')
              else
                @get('model')

      model.delete().then =>
        @get('parentController').send 'showMore'
