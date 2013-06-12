Radium.SidebarAddressesView = Radium.InlineEditorView.extend
  keyDown: (evt) ->
    return if evt.keyCode == 9

    @_super.apply this, arguments

  change: (evt) ->
    #override base

