Radium.Router.reopen
  location: 'history'

# renderTemplate: function() {
#   this.render('myPost', {   // the template to render
#     into: 'index',          // the template to render into
#     outlet: 'detail',       // the name of the outlet in that template
#     controller: 'blogPost'  // the controller to use for the template
#   });
# }
#

Radium.ApplicationRoute = Ember.Route.extend
  events:
    toggleDrawer: (name) ->
      if @get('router.openDrawer') == name
        # FIXME: find a way to disconnect this
        @render 'nothing', into: 'drawer_panel'
        @set 'router.openDrawer', null
      else
        @render name, into: 'drawer_panel'
        @set 'router.openDrawer', name

  renderTemplate: ->
    @render()
    @render 'drawer_panel', outlet: 'drawerPanel'

Radium.DashboardRoute = Ember.Route.extend
  renderTemplate: ->
    @render 'unimplemented'

Radium.Router.map ->
  @route 'dashboard'
  @route 'messages'
