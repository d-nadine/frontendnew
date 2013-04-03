require 'lib/radium/checklist_total_mixin'

Radium.Checklist = Radium.Model.extend Radium.ChecklistTotalMixin,
  checklistItems: DS.hasMany('Radium.ChecklistItem')
  deal: DS.belongsTo('Radium.Deal')
