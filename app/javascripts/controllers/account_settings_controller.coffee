Radium.AccountSettingsController = Radium.ObjectController.extend
  preNegotiatingStates: [
    'unpublished'
    'published'
  ]
  postNegotiatingStates: [
    'closed'
    'lost'
  ]

  dealStates: (->
    preNegotiatingStates = @get 'preNegotiatingStates'
    negotiatingStates = @get('negotiatingStates') || []
    postNegotiatingStates = @get 'postNegotiatingStates'

    negotiatingStates.concat(postNegotiatingStates)
  ).property('negotiatingStates.[]')
