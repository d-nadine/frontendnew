Radium.EmailsNewController = Radium.Controller.extend Ember.Evented,
  newEmail: Radium.EmailForm.create()

  queryParams: ['bulkEmail']

  isBulkEmail: Ember.computed.equal 'bulkEmail', "true"

  bulkEmail: null
