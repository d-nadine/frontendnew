Radium.ContactImportJob = Radium.Model.extend
  headers: DS.attr('array')
  tagNames: DS.attr('array', defaultValue: [])
  additionalFields: DS.attr('array', defaultValue: [])
  contactStatus: DS.belongsTo('Radium.ContactStatus')
  fileName: DS.attr('string')
  createdAt: DS.attr('datetime')
  updatedAt: DS.attr('datetime')
  importedCount: DS.attr('number')
  totalCount: DS.attr('number')
  finished: DS.attr('boolean')
  importStatus: DS.attr('string')
  importErrors: DS.hasMany('Radium.ImportJobError')
  public: DS.attr('boolean')
  assignedTo: DS.belongsTo('Radium.User')
  emailMarkers: DS.attr('array')
  phoneNumberMarkers: DS.attr('array')
  customFieldMappings: DS.attr('array')

  isProcessing: Ember.computed 'importStatus', ->
    @get('importStatus') == 'processing'

  isDeleting: Ember.computed 'importStatus', ->
    @get('importStatus') == 'deleting'

  isFinished: Ember.computed 'importStatus', ->
    return false if @get('isProcessing') || @get('isDeleting')

    @get('finished') || @get('importStatus') == 'finished'
