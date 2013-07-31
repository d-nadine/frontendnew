Radium.AutocompleteAll = Radium.Model.extend
  name: DS.attr('string')
  email: DS.attr('string')
  company_name: DS.attr('string')

  person: ((key, value) ->
    if arguments.length == 2 && value
      debugger
      property = value.constructor.toString().humanize()
      associationName = "#{property}"
      @set associationName, value
    else
      @get('user') || @get('contact')
  ).property('user', 'contact')
  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')
