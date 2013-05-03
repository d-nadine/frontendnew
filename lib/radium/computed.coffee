require 'forms/call_form'
require 'forms/discussion_form'
require 'forms/meeting_form'
require 'forms/todo_form'
require 'lib/radium/aggregate_array_proxy'
require 'lib/radium/task_list'
require 'forms/deal_form'
require 'forms/contact_form'

Radium.computed = {}

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

<<<<<<< HEAD
Radium.computed.kindOf = (property, type) ->
  Ember.computed property, (key) ->
    @get(property) instanceof type
=======
Radium.computed.primary = (collection) ->
  dependentKey = "#{collection}.@each.isPrimary"

  Ember.computed dependentKey, ->
    return unless @get(collection).get('length')

    @get(collection).find (item) ->
      item.get('isPrimary')
>>>>>>> address to company
