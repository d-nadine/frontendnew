require 'lib/radium/combobox'

Radium.LocationPicker = Radium.Combobox.extend
  classNames: ['location-picker-control-box']
  placeholder: 'location'

  sourceBinding: 'controller.locations'
  valueBinding: 'controller.location'

  # No need to use the transform since
  # we're just setting text and not worrying about
  # looking up an ember object
  queryBinding: 'controller.location'

  setValue: (object) ->
    @set 'value', object.get('name')

  leaderView: Radium.View.extend
    template: Ember.Handlebars.compile """
      <i class="ss-icon ss-location"></i>
    """

  footerView: Radium.View.extend
    classNames: ["map-link"]
    template: Ember.Handlebars.compile """
      <a {{action openMap}} href="#">Map</a>
    """
