Radium.DrawerPanelView = Ember.View.extend
  didInsertElement: ->
    @$("#admin-menu").popover
     html: true
     title: 'Dev Toolbox'
     content: @$("#admin-popover").html()
