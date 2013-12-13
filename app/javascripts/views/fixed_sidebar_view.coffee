require 'lib/radium/scrollable_mixin'

Radium.FixedSidebarView = Radium.View.extend Radium.ScrollableMixin,
  classNames: ['sidebar-view']
  didInsertElement: ->
    @container.lookup('controller:application').set('isTwoColumn', true)
  willDestroyElement: ->
    @container.lookup('controller:application').set('isTwoColumn', false)