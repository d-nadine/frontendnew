require 'lib/radium/aggregate_array_proxy'

Radium.TaskList = Radium.AggregateArrayProxy.extend Ember.SortableMixin,
  sortProperties: ['time']
