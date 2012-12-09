class Factory
  constructor: ->
    @definitions = {}

  sequence: (callback) ->
    counter = 0
    callback ?= (i) -> "#{i}"

    -> callback(++counter)

  define: (klass, options, attributes) ->
    if @definitions.hasOwnProperty klass
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
    attributes.id ||= @sequence()

    parent = options.from

    if parent and @definitions.hasOwnProperty(parent)
      attributes = $.extend {}, @definitions[parent].attributes, attributes
    else if parent and !@definitions.hasOwnProperty(parent)
      throw new Error("Undefined factory: #{parent}")

    @definitions[klass] = attributes

  build: (klass, attributes = {}) ->
    unless @definitions.hasOwnProperty klass
      throw new Error("there is no factory definition for #{klass}")

    definition = @definitions[klass]
    instance = $.extend {}, definition, attributes

    for k, v of instance when typeof v is 'function'
      result = instance[k]()
      delete instance[k]
      instance[k] = result

    instance

  tearDown: ->
    for k, v of @definitions
      delete @definitions[k]

window.Factory = new Factory()
