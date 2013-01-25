Radium.PipelineController = Em.ArrayController.extend
  statusesBinding: 'pipelineStatusController'
  statusBinding: 'pipelineStatusController.status'
  currentTypeBinding: 'pipelineStatusController.currentType'

  currentType: ( ->
    status = @get('status')

    return unless status

    if status == 'lead' || status == 'lost'
      Radium.Contact
    else
      Radium.Deal
  ).property('status')

  content: ( ->
    status = @get('status')
    return unless status
    # FIXME: replace with real query
    @get('currentType').find(statusFor: status).map (item) ->
      Radium.PipelinePresenter.create content: item
  ).property('status')
