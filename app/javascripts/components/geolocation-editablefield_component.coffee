require 'components/editable-textbox_component'
require 'components/geo_location_mixin'
require 'mixins/containing_controller_mixin'
require 'lib/radium/buffered_proxy'

Radium.GeolocationEditablefieldComponent = Radium.EditableTextboxComponent.extend Radium.GeoLocationMixin,
  Radium.ContainingControllerMixin,

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    Ember.run.scheduleOnce 'afterRender', this, '_afterRender'

  _afterRender: ->
    @_super.apply this, arguments

    @initializeGoogleGeo([@$()])

  bufferedProxy: Ember.computed 'model', ->
    BufferedObjectProxy.create content: @get('model')

  fillInAddress: (autocomplete) ->
    p autocomplete
    debugger
