require 'mixins/editable_mixin'

Radium.EditableTextboxComponent = Ember.TextField.extend Radium.EditableMixin,
  setMarkup: ->
    value = ( =>
      return unless potential = @get('bufferedProxy').get(@get('bufferKey'))

      if potential instanceof DS.Model
        # FIXME: need to configure other keys
        return potential.get('displayName')

      potential)() || ''

    p value
    @set('value', value)
