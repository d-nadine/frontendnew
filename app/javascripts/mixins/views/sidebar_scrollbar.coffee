Radium.SidebarScrollbarMixin = Em.Mixin.create
  didInsertElement: ->
    $('#scrollarea').tinyscrollbar_update()
