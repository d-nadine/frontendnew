#  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`

Radium.Core = DS.Model.extend
  primaryKey: 'id'

  createdAt: DS.attr("datetime")
  updatedAt: DS.attr("datetime")

  type: (->
    Radium.Core.typeToString(@constructor)
  ).property()
  strTypeBinding: 'type'

  domClass: (->
    "#{@get('type')}_#{@get('id')}"
  ).property('type', 'id')

Radium.Core.reopenClass
  root: ->
    if @superclass == Radium.Core
      this
    else
      @superclass.root()

  typeFromString: (str) ->
    Radium[Em.String.classify(str)]

  typeToString: (type) ->
    type.toString().split('.').slice(-1)[0].underscore()

  isInStore: (id)->
    !!Radium.store.typeMapFor(this).idToCid[id]
