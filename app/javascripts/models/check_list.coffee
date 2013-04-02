Radium.Checklist = Radium.Model.extend
  checklistItems: DS.hasMany('Radium.ChecklistItem')
  deal: DS.belongsTo('Radium.Deal')
