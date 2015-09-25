require 'mixins/containing_controller_mixin'

Radium.ContactLinkComponent = Ember.Component.extend Radium.ContainingControllerMixin,
  actions:
    linkAction: (contact) ->
      return unless linkAction = @get('linkAction')

      @get('containingController').send linkAction, contact

      false
