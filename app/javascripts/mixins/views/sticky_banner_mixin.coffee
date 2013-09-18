Radium.StickyBannerMixin = Ember.Mixin.create
  classNameBindings: ['isScrolled']
  isScrolled: false
  didInsertElement: ->
    Ember.$(window).on('scroll.stickyScroll', =>
      if ($(window).scrollTop() > 5)
        @set('isScrolled', true)
      else
        @set('isScrolled', false)

      Ember.$(window).trigger('stickyChange')
    )
  willDestroyElement: ->
    Ember.$(window).off('scroll.stickyScroll')