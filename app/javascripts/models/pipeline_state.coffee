Radium.PipelineState = Radium.Model.extend
  name: DS.attr('string')
  position: DS.attr('number')
  checklists: DS.hasMany('Radium.PipelineChecklist')