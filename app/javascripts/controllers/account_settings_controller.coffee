Radium.AccountSettingsController = Radium.ObjectController.extend
  postNegotiatingStatuses: [
    'closed'
    'lost'
  ]

  inOrder: (->
    negotiatingStatuses = @get 'negotiatingStatuses'
    postNegotiatingStatuses = @get 'postNegotiatingStatuses'

    negotiatingStatuses.concat(postNegotiatingStatuses)
  ).property('negotiatingStatuses')
