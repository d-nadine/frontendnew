Radium.PipelineController = Em.ArrayController.extend Radium.CheckableMixin,
  content: ( ->
    status = @get('pipelineStatusController.status')
    return unless status
    Radium.Contact.find() #statusFor: status
  ).property('pipelineStatusController.status')
