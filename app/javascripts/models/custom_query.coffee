Radium.CustomQuery = DS.Model.extend
  uid: DS.attr('string')
  name: DS.attr('string')
  customQueryParts: DS.hasMany('Radium.CustomQueryPart')
