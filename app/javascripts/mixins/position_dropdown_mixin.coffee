Radium.PositionDropdownMixin = Ember.Mixin.create
  actions:
    positionMenu: (e) ->
      return if @$().hasClass 'open'

      @positionDropdown()

  positionDropdown: () ->
    menu = @$('.dropdown-menu')

    a = @$('.dropdown-toggle')

    position = a.position()

    menu.css({top: position.top + 20, left: position.left})
