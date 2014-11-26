Radium.PeopleIndexView = Radium.View.extend
  setup: Ember.on 'didInsertElement', ->
    @resizeTableContainer()
    $(window).on 'resize.table-container-resize', @resizeTableContainer.bind(this)
    $(document).on 'click.clear-menu', @clearMenus.bind(this)
    @$('.col-selector .dropdown-toggle').on 'click.col-selector', @showHideColumnSelector
    Ember.run.scheduleOnce 'afterRender', this, 'addEventHandlers'

  showHideColumnSelector: (e) ->
    target = $(e.target)

    parent = target.parents('.col-selector')

    parent.toggleClass('open')

  clearMenus: (e) ->
    target = $(e.target)
    menu = $('.col-selector')

    if e.target == menu || target.parents('.col-selector').length
      return

    menu.removeClass('open') if menu.hasClass('open')

  resizeTableContainer: ->
    tableContainer = @$('.table-container')

    buffer = 100

    left = tableContainer.offset().left
    availableWidth = document.body.clientWidth - left - buffer

    tableContainer.width(availableWidth)

  addEventHandlers: ->
    Ember.run.later =>
      return unless @get('controller.showMoreMenu')

      return unless @$('.show-more')?.length

      @removeObserver 'controller.showMoreMenu', this, 'addEventHandlers'

      self = this

      @$('.show-more').on 'click.show-more', (e) ->
        el = $(this)

        text = if el.text() == 'Show More'
          'Hide'
        else
          'Show More'

        el.text text

        self.$('.nav-pills.more').slideToggle(100)

        false
    , 1000

  teardown: Ember.on 'willDestroyElement', ->
    @$('ul.col-menu').off 'click.col-menu'
    @$('.show-more').off 'click.show-more'
    $(window).off 'resize.table-container-resize'
    @$('.col-selector .dropdown-toggle').off 'click-col-selector'
    $(document).off 'click.clear-menu'