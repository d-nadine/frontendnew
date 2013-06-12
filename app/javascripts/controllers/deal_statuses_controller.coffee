Radium.DealStatusesController = Ember.Controller.extend
  needs: ['settings']
  negotiatingStatuses: Ember.computed.alias('controllers.settings.negotiatingStatuses')

  postNegotiatingStatuses: [
    'closed'
    'lost'
  ]

  inOrder: (->
    negotiatingStatuses = @getWithDefault 'negotiatingStatuses', []
    postNegotiatingStatuses = @get 'postNegotiatingStatuses'

    negotiatingStatuses.concat(postNegotiatingStatuses)
  ).property('negotiatingStatuses')
