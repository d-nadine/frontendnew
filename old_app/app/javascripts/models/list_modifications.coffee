Radium.AddList = Radium.Model.extend
  list: DS.belongsTo('Radium.List')
  reference: Ember.computed '_referenceContact', '_referenceCompany', (key, value) ->
    if arguments.length == 2 && value
      property = "_reference#{value.constructor.toString().split('.')[1].toLowerCase().capitalize()}"
      @set property, value
    else
      @get('_referenceContact') ||
      @get('_referenceCompany') ||
      @get('_referenceThirdpartyIntegration')

  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceCompany: DS.belongsTo('Radium.Company')
  _referenceThirdpartyintegration: DS.belongsTo('Radium.ThirdpartyIntegration')

Radium.RemoveList = Radium.AddList.extend()
