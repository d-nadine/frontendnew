require 'forms/call_form'
require 'forms/discussion_form'
require 'forms/meeting_form'
require 'forms/todo_form'
require 'lib/radium/aggregate_array_proxy'
require 'forms/deal_form'
require 'forms/contact_form'

Radium.computed = {}

Radium.computed.isToday = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    @get(dependentKey).isToday()

Radium.computed.isPast = (dependentKey) ->
  Ember.computed dependentKey, (key) ->
    return unless @get(dependentKey)

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
  properties = Array.prototype.slice.call arguments

  args = properties.map (prop) => "#{prop}"

  options =
    initialValue: []
    addedItem: (array, item, changeMeta, instanceMeta) ->
      return array if array.contains item

      observer = =>
        return unless item.get('isLoaded')

        item.removeObserver 'isLoaded', observer

        array.addObject(item)

      if item.get('isLoaded')
        observer()
      else
        item.addObserver 'isLoaded', observer

      array

    removedItem: (array, item, changeMeta, instanceMeta) ->
      return unless array.length
      return unless array.contains(item)

      array.removeObject(item)

      array

  args.push options

  Ember.arrayComputed.apply this, args

Radium.computed.tasks = Radium.computed.aggregate

Radium.computed.required = ->
  Ember.computed ->
    throw new Error("#{@constructor} does not implement the tasks interface")

Radium.computed.kindOf = (property, type) ->
  Ember.computed property, (key) ->
    @get(property) instanceof type

Radium.computed.primary = (collection) ->
  dependentKey = "#{collection}.@each.isPrimary"

  Ember.computed dependentKey, ->
    return unless @get(collection).get('length')

    @get(collection).find (item) ->
      item.get('isPrimary')

Radium.computed.total = (collection, key = 'value') ->
  dependentKey = "#{collection}.[]"

  Ember.computed dependentKey, ->
    return 0 unless @get(collection).get('length')

    @get(collection).reduce((preVal, item) ->
      preVal + item.get(key) || 0
    , 0, key)

Radium.computed.addAllKeysProperty = (context, propertyName, objectPath, func) ->
  subject = context.get(objectPath)

  args = Ember.keys(subject).map((key) -> "#{objectPath}.#{key}")

  args.push func

  Ember.defineProperty(context, propertyName, Ember.computed.apply(this, args))
