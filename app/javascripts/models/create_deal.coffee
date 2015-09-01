Radium.CreateDeal = Radium.Model.extend
  company: DS.belongsTo('Radium.Company')
  companyName: DS.attr('string')
  companyLogo: DS.attr('string')
  companyWebsite: DS.attr('string')
  name: DS.attr('string')