Radium.PipelineStatus = DS.Model.extend
  status: DS.attr('string')
  settings: DS.belongsTo('Radium.Settings')
