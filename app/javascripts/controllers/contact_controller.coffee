Radium.ContactController = Radium.Controller.extend Radium.AttachedFilesMixin,
  attachments: Ember.computed.oneWay 'model.attachments'
  customFields: Ember.A()
  queryParams: ['form']
  form: null
