Radium.Router.reopen
  location: 'history'

Radium.Router.map ->
  @route 'dashboard'
  @route 'messages'
  @resource 'pipeline', ->
    @route 'leads'
    @route 'negotiating'
    @route 'closed'
    @route 'lost'
