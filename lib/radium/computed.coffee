require 'forms/todo_form'

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

Radium.computed.newForm = (form) ->
  defaultsName = "#{form}FormDefaults"
  type = Radium["#{form.capitalize()}Form"]

  Ember.computed defaultsName, ->
    Ember.assert "no #{defaultsName} specified", @get(defaultsName)
    type.create
      content: Ember.Object.create()
      isNew: true
      defaults: @get(defaultsName)
