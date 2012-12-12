#  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`

Radium.Core = DS.Model.extend
  primaryKey: 'id'

  createdAt: DS.attr("datetime")
  updatedAt: DS.attr("datetime")

  type: (->
    Radium.Core.typeToString(@constructor)
  ).property()

  # TODO: Review causing records to be rematerialized
  # used by FilteredCollectionMixin
  # strTypeBinding: 'type'

  domClass: (->
    "#{@get('type')}_#{@get('id')}"
  ).property('type', 'id')

  eachPolymorphicAttribute: (callback, binding) ->
    Ember.get(this.constructor, 'polymorphicAttributes').forEach( ( (name, meta) ->
      callback.call(binding, name, meta)
    ), binding)

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

  isInStore: (id, store)->
    #should the model reference the store?
    store ?= Radium.get('router.store')
    store.isInStore this, id

  polymorphicAssociationsByName: Ember.computed( ->
    map  = Ember.Map.create()

    @eachAssociation (name, association) ->
      if polymorphicName = association.options?.polymorphicFor
        unless map.get polymorphicName
          map.set polymorphicName, []

        map.get(polymorphicName).pushObject(association)

    map
  )

  polymorphicAttributes: Ember.computed ->
    map = Ember.Map.create()

    @eachComputedProperty (name, meta) ->
      if meta.polymorphic
        meta.name = name
        map.set(name, meta)

    map
