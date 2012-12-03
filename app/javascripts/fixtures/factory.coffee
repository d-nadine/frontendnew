window.Factory = do($) ->
  f = {}

  Definition = (name, options) ->
    @name = name
    @defaults = $.extend options.parent, options.defaults
    @plural = "#{name.toLowerCase().pluralize()}"
    @

  define = (klass, options = {}) ->
    options.defaults ?= {}
    options.parent = if options.parent then build(options.parent) else {}

    def = new Definition(klass, options)

    f[klass] = def
    f[def.plural] = {} unless f[def.plural]

    return if options.abstract

    unless f[def.plural].default
      f[def.plural].default = build(klass, def.defaults)

  build = (klass, name, options = {}) ->
    unless f.hasOwnProperty klass
      throw "there is no factory definition for #{klass}"

    if arguments.length == 2 && typeof name == 'object'
      options = name
      name = null

    options ?= {}
    definition = f[klass]

    instance = $.extend {}, definition.defaults, options
    instance.def = f[klass]

    if typeof name == "string"
      f[definition.plural][name] = instance

    instance

  getDefinitions = ->
    for own key, value of f
      continue if typeof value is "function"
      continue if value instanceof Definition
      value


  f.define =  define
  f.build =  build
  f.getDefinitions = getDefinitions
  f
