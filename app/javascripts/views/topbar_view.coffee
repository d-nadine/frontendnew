Radium.TopbarView = Em.View.extend
  templateName: 'radium/topbar'
  pipelineStatusesBinding: 'Radium.router.pipelineStatusController.statuses'

  # FIXME: see ember issue #1796
  inboxFolderName: 'inbox'
