Radium.ChecklistItem = Radium.Model.extend
  kind: DS.attr('string')
  description: DS.attr('string')
  checkList: DS.belongsTo('Radium.Checklist')
  weight: DS.attr('number')
  isFinished: DS.attr('boolean')
