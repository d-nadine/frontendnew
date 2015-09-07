Radium.CreateDeal = Radium.Model.extend
  company: DS.belongsTo('Radium.Company')
  companyName: DS.attr('string')
  companyLogo: DS.attr('string')
  companyWebsite: DS.attr('string')
  contactName: DS.attr('string')
  contact: DS.belongsTo('Radium.Contact')
  name: DS.attr('string')
  list: DS.belongsTo('Radium.List')