Radium.ChecklistItem = Radium.Model.extend
  kind: DS.attr('string')
  description: DS.attr('string')
  weight: DS.attr('number')
  date: DS.attr('number')
  isFinished: DS.attr('boolean')
  taskId: DS.attr('number')
