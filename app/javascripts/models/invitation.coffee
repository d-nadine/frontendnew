Radium.Invitation = Radium.Model.extend
  meeting: DS.belongsTo 'Radium.Meeting'

  state: DS.attr('string')

  reference: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceUser') || @get('_referenceContact')
  ).property('_referenceUser', '_referenceContact')
  _referenceContact: DS.belongsTo('Radium.Contact', inverse: null)
  _referenceUser: DS.belongsTo('Radium.User', inverse: null)

