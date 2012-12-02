Radium.reopen
  # Create polymorphic property for given key.
  # It's really dead simple implementation which will not
  # behave as real association.
  #
  # TODO: add polymorphic keys support to ember-data
  polymorphicAttribute: ->
    Ember.computed( (key, record) ->
      if arguments.length == 1
        record = null
        find = (association) ->
          record = @get(association.key)

        Ember.get(@constructor, 'polymorphicAssociationsByName').get(key).find find, this

        record
      else
        find = (association) ->
          association.type == record.constructor
        clear = (association) ->
          if @get(association.key) && association.type != record.constructor
            @set association.key, null

        associations = Ember.get(@constructor, 'polymorphicAssociationsByName').get(key)
        associations.forEach clear, this
        association = associations.find find, this
        console.log 'set', association.key, record.toString()
        @set association.key, record
        record
    ).property().meta(polymorphic: true)

  defineFeedAssociation: ->
    args = Array.prototype.slice.call(arguments)
    type = args.shiftObject()

    associated = ->
      associatedRecords = []
      self = this

      args.forEach (propertyName) ->
        if record = self.get(propertyName)
          if record.constructor == type
            associatedRecords.pushObject record

      associatedRecords
    associated = associated.property.apply(associated, args)
    associated
