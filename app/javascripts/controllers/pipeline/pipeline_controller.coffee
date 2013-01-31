Radium.PipelineController = Em.ArrayController.extend
  needs: ['pipelineStatus']
  statusesBinding: 'controllers.pipelineStatus'
  statusBinding: 'controllers.pipelineStatus.status'

  currentType: ( ->
    status = @get('status')

    return unless status

    if status == 'lead' || status == 'lost'
      Radium.Contact
    else
      Radium.Deal
  ).property('status')

  items: ( ->
    status = @get('status')
    return unless status
    # FIXME: replace with real query
    @get('currentType').find(statusFor: status).map (item) ->
      Radium.PipelinePresenter.create content: item
  ).property('status', 'currentType')
