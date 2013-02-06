Radium.PipelineStatus = DS.Model.extend
  status: DS.attr('string')
  settings: DS.belongsTo('Radium.Settings')

  # FIXME: Is not bound if on the itemController
  isExpanded: false
