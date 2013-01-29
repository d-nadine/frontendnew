Ember.Application.initializer
  name: 'templatesRenamme'
  initialize: ->
    for name, template of Ember.TEMPLATES
      newKey = name.replace("/", ".")
      Ember.TEMPLATES[newKey] = template
