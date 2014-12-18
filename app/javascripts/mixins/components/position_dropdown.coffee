Radium.PositionDropdownMixin = Ember.Mixin.create
  actions:
    positionMenu: (e) ->
      @positionDropdown()

  setup: Ember.on 'didInsertElement', ->
    $(window).on 'scroll', @positionDropdown.bind(this)

  teardown: Ember.on 'willDestroyElement', ->
    $(window).off 'scroll'

  positionDropdown: (e) ->
    return if @$().hasClass 'open'

    a = @$('.dropdown-toggle')
    menu = @$('.dropdown-menu')

    offset = a.position()

    menu.css({top: offset.top + 20, left: offset.left})
