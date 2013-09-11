Radium.CompanyView = Radium.View.extend
  classNames: ['page-view']
  classNameBindings: ['isScrolled']
  layoutName: "layouts/two_column"
  isScrolled: false
  didInsertElement: ->
    Ember.$(window).on('scroll.stickyScroll', =>
      if ($(window).scrollTop() > 5)
        @set('isScrolled', true)
      else
        @set('isScrolled', false)

    )
  willDestroyElement: ->
    Ember.$(window).off('scroll.stickyScroll');