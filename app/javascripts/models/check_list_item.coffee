Radium.ChecklistItem = Radium.Model.extend
  kind: DS.attr('string')
  description: DS.attr('string')
  deal: DS.belongsTo('Radium.Deal')
  weight: DS.attr('number')
  isFinished: DS.attr('boolean')
