Radium.ContactImportJob = Radium.Model.extend
  headers: DS.attr('array')
  rows: DS.attr('array', defaultValue: [])
  tagNames: DS.attr('array', defaultValue: [])
  additionalFields: DS.attr('array', defaultValue: [])
  status: DS.attr('string')
  fileName: DS.attr('string')
  createdAt: DS.attr('datetime')
  updatedAt: DS.attr('datetime')
  importedCount: DS.attr('number')
  totalCount: DS.attr('number')
  finished: DS.attr('boolean')
  importStatus: DS.attr('string')

  isProcessing: Ember.computed 'importStatus', ->
    @get('importStatus') == 'processing'
