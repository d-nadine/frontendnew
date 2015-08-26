Radium.NavBarComponent = Ember.Component.extend
  actions:
    logOut: ->
      @sendAction "logOut"

      false

    toggleNotifications: ->
      @sendAction "toggleNotifications"

      false

    transitionToTag: (tag) ->
      @sendAction "transitionToTag", tag

      false

  attributeBindings: ['role']
  classNames: ['topbar', 'navbar navbar-inverse navbar-fixed-top']
  role: "header"

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    contactsNav = @$('.addressbook-top-nav')

    contactsNav.on 'mouseenter', =>
      return if @get('application.currentPath') == "addressbook.companies"
      contactsNav.addClass('open')

    contactsNav.on 'mouseleave', ->
      contactsNav.removeClass('open')

    contactsNav.on 'click', 'a', ->
      contactsNav.removeClass('open')

    @$('.addressbook-top-nav .dropdown-menu').on 'click', 'a', ->
      contactsNav.removeClass('open')

    collapse = @$('.nav-collapse')

    collapse.on 'click', 'a', ->
      collapse.collapse('hide')

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @$('.nav-collapse').off('click')

    @$('.addressbook-top-nav')
      .off('mouseenter')
      .off('mouseleave')
      .off('click')

    @$('.addressbook-top-nav .dropdown-menu').off 'click'

  application: Ember.computed ->
    @container.lookup('controller:application')
