Radium.FixtureAdapter.reopenClass
  createPreFilterContact: (contact, transaction) ->
    companyName = contact.get("companyName")

    return  unless companyName

    company = Radium.Company.all().toArray().find((company) ->
      company.get("name") is companyName
    )

    if company
      contact.set "company", company
      return

    company = Radium.Company.createRecord(name: companyName)
    company.set "primaryContact", contact
    company.get("contacts").addObject contact
    company.set "user", contact.get("user")

    transaction.adoptRecord company
