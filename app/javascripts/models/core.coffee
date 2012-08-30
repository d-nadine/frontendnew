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
  Radium[Em.String.classify(str)]

Radium.Core.typeToString = (type) ->
  type.toString().split('.').slice(-1)[0].underscore()
