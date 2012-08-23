Radium.Contact = Radium.Person.extend
  status: DS.attr("string")
  # TODO: from discussion with Adam, displayName should be either
  #       name, email or phoneNumber
  displayName: DS.attr("string", key: "display_name")
