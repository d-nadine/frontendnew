Radium.CustomQueryPart = DS.Model.extend
  field: DS.attr('string')
  operator: DS.attr('string')
  operatorType: DS.attr('string')
  value: DS.attr('string')
  customfieldid: DS.attr('number')

  isBoolean: Ember.computed 'operatorType', ->
    @get('operatorType') == "boolean"
