Radium.XContactComponent = Ember.Component.extend
  actions:
    addTag: (tag) ->
      @sendAction "addTag", @get('contact'), tag

      false

    removeTag: (tag) ->
      @sendAction "removeTag", @get('contact'), tag

      false

    confirmDeletion: ->
      @sendAction "confirmDeletion"

      false

  classNames: ['two-column-layout']

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    Ember.run.scheduleOnce 'afterRender', this, 'addListeners'
    $(window).on "resize.sidebar", @resizeSidebar.bind(this)

  resizeSidebar: (e) ->
    return unless right = @$('.contact-sidebar-component')

    height = $(window).height() - right.position().top - 100

    right.height(height)

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    $('resize.sidebar').off 'resize'

