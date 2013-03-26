require 'forms/call_form'
require 'forms/discussion_form'
require 'forms/meeting_form'
require 'forms/todo_form'
require 'lib/radium/aggregate_array_proxy'
require 'lib/radium/task_list'

Radium.computed = {}

Radium.computed.equal = (dependentKey, value) ->
  Ember.computed dependentKey, (key) ->
    @get(dependentKey) == value

Radium.computed.isToday = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    @get(dependentKey).isToday()

Radium.computed.isPast = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    @get(dependentKey).isPast()

Radium.computed.isFuture = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    @get(dependentKey).isFuture()

Radium.computed.daysOld = (dependentKey, days) ->
  Ember.computed dependentKey, (key) ->
    now = Ember.DateTime.create()
    @get(dependentKey).daysApart(now) >= days

Radium.computed.isPresent = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    !Ember.isEmpty(@get(dependentKey))

Radium.computed.newForm = (form, properties = {}) ->
  defaultsName = "#{form}FormDefaults"
  type = Radium["#{form.capitalize()}Form"]

  Ember.computed defaultsName, ->
    Ember.assert "no #{defaultsName} specified", @get(defaultsName)

    type.create properties,
      content: Ember.Object.create()
      isNew: true
      defaults: @get(defaultsName)

Radium.computed.aggregate = ->
  arrays = Array.prototype.slice.call arguments

  Ember.computed ->
    aggregate = Radium.AggregateArrayProxy.create()
    arrays.forEach (array) => aggregate.add @get(array)
    aggregate

Radium.computed.tasks = ->
  arrays = Array.prototype.slice.call arguments

  Ember.computed ->
    aggregate = Radium.AggregateArrayProxy.create()
    arrays.forEach (array) => aggregate.add @get(array)
    aggregate

Radium.computed.required = ->
  Ember.computed ->
    throw new Error("#{@constructor} does not implement the tasks interface")
