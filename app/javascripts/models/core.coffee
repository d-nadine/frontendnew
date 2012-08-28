#  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`

Radium.Core = DS.Model.extend
  createdAt: DS.attr("datetime", key: "created_at")
  updatedAt: DS.attr("datetime", key: "updated_at")
  type: (->
    Radium.Core.typeToString(@constructor)
  ).property()
  domClass: (->
    "#{@get('type')}_#{@get('id')}"
  ).property('type', 'id')

Radium.Core.typeFromString = (str) ->
  type = str.replace /_([a-z])|^([a-z])/g, (match, p1, p2) -> (p1 || p2).toUpperCase()
  Radium[type]

Radium.Core.typeToString = (type) ->
  parts = type.toString().split('.')
  type = parts[parts.length - 1]
  type.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1)

# TODO: prepare something similar to inflector
Radium.Core.pluralize = (str) ->
  "#{str}s"
