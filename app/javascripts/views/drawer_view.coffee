require 'lib/radium/scrollable_mixin'

Radium.DrawerView = Radium.View.extend #Radium.ScrollableMixin,
  classNames: ['drawer-view']
  didInsertElement: ->
    @$()[0].offsetWidth
    @$().addClass 'open'

  close: ->
    @$().one($.support.transition.end, =>
      @get('container').lookup('router:main').send('closeDrawer')
    )

    @$().removeClass 'open'
