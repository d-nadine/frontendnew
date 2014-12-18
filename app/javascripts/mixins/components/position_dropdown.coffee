Radium.PositionDropdownMixin = Ember.Mixin.create
  actions:
    positionMenu: (e) ->
      return if @$().hasClass 'open'

      @positionDropdown()

  eventNamespace: Ember.computed 'elementId', ->
    "scroll.#{@get('elementId')}"

  didInsertElement: ->
    @_super.apply this, arguments
    $(window).on @get('eventNamespace'), @scrollDropdown.bind(this)

  willDestroyElement: ->
    @_super.apply this, arguments
    $(window).off @get('eventNamespace')

  scrollDropdown: ->
    menu = @$('.dropdown-menu')

    return unless menu.is(':visible')

    @positionDropdown()

  positionDropdown: () ->
    menu = @$('.dropdown-menu')

    a = @$('.dropdown-toggle')

    position = a.position()

    menu.css({top: position.top + 20, left: position.left})
