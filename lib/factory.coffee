window.Factory = do($) ->
  f = {}
  definitions = {}

  Definition = (name, attributes) ->
    @name = name
    @attributes = attributes
    @

  sequence = (callback) ->
    counter = 0
    callback ?= (i) -> "#{i}"

    -> callback(++counter)

  define = (klass, options, attributes) ->
    if definitions.hasOwnProperty klass
      throw new Error("there is an existing factory definition for #{klass}")

    if arguments.length == 2
      attributes = options
      options = {}
    else if arguments.length == 3
      options ||= {}
    else if arguments.length == 1
      options = {}
      attributes = {}

    attributes ||= {}
    attributes.id ||= sequence()

    parent = options.from

    if parent and definitions.hasOwnProperty(parent)
      attributes = $.extend {}, definitions[parent].attributes, attributes
    else if parent and !definiations.hasOwnProperty(parent)
      throw new Error("Undefined factory: #{parent}")

    definitions[klass] = attributes

  build = (klass, attributes = {}) ->
    unless definitions.hasOwnProperty klass
      throw new Error("there is no factory definition for #{klass}")

    definition = definitions[klass]
    instance = $.extend {}, definition, attributes

    for k, v of instance when typeof v is 'function'
      result = instance[k]()
      delete instance[k]
      instance[k] = result

    instance

  # definitions = ->
  #   for own key, value of f
  #     continue if typeof value is "function"
  #     continue if value instanceof Definition
  #     value

  # association = (klass) ->
  #   unless f.hasOwnProperty klass
  #     throw "there is no factory definition for #{klass}"

  #   args = Array.prototype.slice.call(arguments)
  #   type = klass.pluralize().toLowerCase()

  #   if $.isArray args[1]
  #     if args.length is 3 and typeof args[2] is "object" and args[2].embedded
  #       return (f[type][instance] for instance in args[1])

  #     return (f[type][instance].id for instance in args[1])

  #   instance = f[type][args[1]]

  #   if args.length is 3 and typeof args[2] is 'object'
  #     instance = $.extend {}, instance, args[2]

  #   instance

  tearDown = ->
    for k, v of definitions
      delete definitions[k]

  f.define =  define
  f.sequence = sequence
  f.build =  build
  #f.association = association
  f.tearDown = tearDown
  f
