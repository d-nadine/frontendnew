Radium.Invitation = Radium.Model.extend
  meeting: DS.belongsTo 'Radium.Meeting'
  email: DS.attr('string')

  status: DS.attr('string')

  person: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1]
      associationName = "_person#{property}"
      @set associationName, value
    else
      @get('_personUser') || @get('_personContact')
  ).property('_personUser', '_personContact')
  _personContact: DS.belongsTo('Radium.Contact')
  _personUser: DS.belongsTo('Radium.User')
