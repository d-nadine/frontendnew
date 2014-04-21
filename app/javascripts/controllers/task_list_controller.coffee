require 'lib/radium/groupable'
require 'lib/radium/show_more_mixin'

Radium.TaskListController = Radium.ArrayController.extend(Radium.ShowMoreMixin)
