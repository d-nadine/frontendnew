Radium.TimePickerView = Ember.View.extend
  templateName: 'forms/time_picker'
  classNames: ['input-append', 'bootstrap-timepicker']
  didInsertElement: ->
    @$('.input-small').timepicker()
