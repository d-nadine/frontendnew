Radium.MessagesEmailItemView = Ember.View.extend Radium.ContentIdentificationMixin,
  trackedToggleSwitch: Radium.ToggleSwitch.extend
    checkedBinding: 'controller.isTracked'
