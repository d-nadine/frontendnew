Radium.PeopleIndexView = Radium.View.extend
  setup: ( ->
    Ember.run.scheduleOnce 'afterRender', this, 'addEventHandlers'

    @$('ul.col-menu li').on 'click.col-men', ->
      check = $(this).find 'input[type=checkbox]'
      check.prop('checked', !check.prop('checked'))
      return false

  ).on 'didInsertElement'

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

  teardown: (->
    @$('ul.col-menu').off 'click.col-men'
    @$('.show-more').off 'click.show-more'
  ).on 'willDestroyElement'