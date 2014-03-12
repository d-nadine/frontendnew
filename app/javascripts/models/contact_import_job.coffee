Radium.ContactImportJob = Radium.Model.extend
  headers: DS.attr('array')
  rows: DS.attr('array')
  createdAt: DS.attr('datetime')
  tagNames: DS.attr('array', defaultValue: [])
  status: DS.attr('string')
  fileName: DS.attr('string')
