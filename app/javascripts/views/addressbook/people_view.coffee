Radium.PeopleIndexView = Radium.View.extend Radium.ScrollTopMixin,
  classNameBindings: ['controller.hidesidebar:hide-sidebar']
  setup: Ember.on 'didInsertElement', ->
    $(document).on 'click.clear-menu', @clearMenus.bind(this)
    @$('.col-selector .dropdown-toggle').on 'click.col-selector', @showHideColumnSelector

  showHideColumnSelector: (e) ->
    target = $(e.target)

    parent = target.parents('.col-selector')

    parent.toggleClass('open')

  clearMenus: (e) ->
    target = $(e.target)
    menu = $('.col-selector')

    if e.target == menu || target.parents('.col-selector').length
      return @resizeTableHeaders()

    menu.removeClass('open') if menu.hasClass('open')

  resizeTableHeaders: ->
    rightHeight = $('.variadic-table:last thead tr th:first').outerHeight() - 1

    Ember.run.next ->
      $('.variadic-table:first thead tr th').each (index, th) ->
        $(th).height(rightHeight)


  resizeTableContainer: ->
    tableContainer = @$('.table-container')

    buffer = 100

    left = tableContainer.offset().left
    availableWidth = document.body.clientWidth - left - buffer

    tableContainer.width(availableWidth)

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    tick = Ember.run.later ->
      el = $('.col-selector input[type=text]')
      el.val('').focus()
      Ember.run.cancel tick
    , 3000

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @$('ul.col-menu').off 'click.col-menu'
    $(window).off 'resize.table-container-resize'
    @$('.col-selector .dropdown-toggle').off 'click-col-selector'
    $(document).off 'click.clear-menu'
