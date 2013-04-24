require 'lib/radium/show_more_mixin'

Radium.MessagesEmailHistoryController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  perPage: 3
