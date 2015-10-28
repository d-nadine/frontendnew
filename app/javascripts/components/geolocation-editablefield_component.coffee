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
    place = autocomplete.getPlace()

    i = 0
    l = place.address_components?.length || 0

    bufferedProxy = @get('bufferedProxy')

    while i < l
      addressType = place.address_components[i].types[0]
      if @componentForm[addressType]
        val = place.address_components[i][@componentForm[addressType]]

        if addressType == 'route'
          street_number = place.address_components[0]['long_name']
          bufferedProxy.set "street", "#{street_number} #{val}"

        unless ["street_number", "route"].contains addressType
          bufferedProxy.set(@modelMap[addressType], val)

      i++

    @send "updateModel"
