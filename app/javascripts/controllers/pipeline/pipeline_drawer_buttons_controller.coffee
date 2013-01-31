Radium.PipelineDrawerButtonsController = Em.Controller.extend
  needs:['pipelineStatus']
  statusBinding: 'controllers.pipelineStatus.status'

  # toggleSearch: (event, context) ->
  #   @get('drawerPanelController').toggleDrawer "#{@get('status')}Search"
