Radium.Workflow = Radium.Model.extend
  name: DS.attr('string')
  position: DS.attr('number')
  checklist: DS.hasMany('Radium.ChecklistItem')
