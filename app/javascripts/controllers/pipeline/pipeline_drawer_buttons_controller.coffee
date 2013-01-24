Radium.PipelineDrawerButtonsController = Em.Controller.extend
  statusBinding: 'pipelineStatusController.status'

  toggleSearch: (event, context) ->
    @get('drawerPanelController').toggleDrawer "#{@get('status')}Search"
