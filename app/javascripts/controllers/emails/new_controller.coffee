Radium.EmailsNewController = Radium.Controller.extend
  newEmail: Radium.EmailForm.create()

  queryParams: ['bulkEmail']

  isBulkEmail: Ember.computed.equal 'bulkEmail', "true"
