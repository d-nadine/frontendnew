App.RdDaterangepicker = Ember.Component.extend
  startDate: new Date()
  endDate: new Date()

  initializeDaterangepicker: (->
    @$('input[name="daterangepicker"]')
  ).on("didInsertElement")
