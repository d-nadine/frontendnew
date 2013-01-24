Radium.PipelineController = Em.ArrayController.extend
  statusesBinding: 'pipelineStatusController.statuses'
  content: ( ->
    status = @get('pipelineStatusController.status')
    return unless status
    Radium.Contact.find(statusFor: status)
  ).property('pipelineStatusController.status')
