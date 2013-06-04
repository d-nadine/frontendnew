Radium.AccountSettingsController = Radium.ObjectController.extend
  preNegotiatingStates: [
    'unpublished'
  ]

  postNegotiatingStates: [
    'closed'
    'lost'
  ]

  dealStates: (->
    preNegotiatingStates = @get 'preNegotiatingStates'
    negotiatingStates = @get('negotiatingStates') || []
    postNegotiatingStates = @get 'postNegotiatingStates'

    preNegotiatingStates.concat(negotiatingStates.concat(postNegotiatingStates))
  ).property('negotiatingStates.[]')
