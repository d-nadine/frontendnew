Radium.NavBarComponent = Ember.Component.extend
  actions:
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
    collapse = @$('.nav-collapse')

    collapse.on 'click', 'a', ->
      collapse.collapse('hide')

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @$('.nav-collapse').off('click')
