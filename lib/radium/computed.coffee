require 'forms/call_form'
require 'forms/discussion_form'
require 'forms/meeting_form'
require 'forms/todo_form'
require 'lib/radium/aggregate_array_proxy'
require 'forms/deal_form'
require 'forms/contact_form'

a_slice = Array.prototype.slice

Radium.computed = {}

Radium.computed.notEqual = (dependentKey, value) ->
  Ember.computed dependentKey, (key, value) ->
    @get(dependentKey) != value

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
  properties = a_slice.call arguments

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
      return array unless array.length
      return array unless array.contains(item)

      array.removeObject(item)

      array

  args.push options

  Ember.arrayComputed.apply this, args

Radium.computed.tasks = ->
  properties = a_slice.call arguments

  args = properties.map (prop) => "#{prop}"

  args.forEach (arg) ->
    args.push "#{arg}.@each.{isFinished,isDeleted}"

  options =
    initialValue: []
    sortFunc: (left, right) ->
      compare = Ember.DateTime.compare left.get("time"), right.get("time")

      if compare == 0
        Ember.compare left.get("displayName"), right.get("displayName")
      else
        compare

    addedItem: (array, item, changeMeta, instanceMeta) ->
      return array if array.contains item
      return array if item.get('isFinished')

      observer = =>
        return unless item.get('isLoaded')

        item.removeObserver 'isLoaded', observer

        return if array.contains item
        return if item.get('isFinished')
        return if item.get('isDeleted')

        array.pushObject item

        array.sort options.sortFunc

      if item.get('isLoaded')
        observer()
      else
        item.addObserver 'isLoaded', observer

      array

    removedItem: (array, item, changeMeta, instanceMeta) ->
      return array unless array.length
      return array unless array.contains(item)

      array.removeObject(item)

      array

  args.push options

  Ember.arrayComputed.apply this, args


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

  if typeof func != 'function'
    args.push.apply(args, a_slice.call(arguments, 3, -1))

  args.push a_slice.call(arguments, -1)[0]

  Ember.defineProperty(context, propertyName, Ember.computed.apply(this, args))
