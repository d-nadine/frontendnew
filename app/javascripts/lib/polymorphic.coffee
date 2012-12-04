Radium.reopen
  # Polymorphic association support
  #
  # Since there is no support for this in ember, this is partly hack over
  # regular associations. Recently ember-data started to require both sides
  # of relationship to be defined at all times. So for example if a post has
  # many comments, comment *needs* to have inverse belongs to post assciation
  # defined.
  #
  # This polymorphic association works by wrapping regular associations. Let's say
  # that we have Comment model, that belongs to commentable, which can be Todo or
  # Meeting.
  #
  # In order to define commentable in Comment model, you just need to use:
  #
  #     Radium.Comment = Radium.Core.extend
  #       commentable: Radium.polymorphicAttribute()
  #
  # When JSON comes from server it will have the following key defined:
  #
  #     commentable: {
  #       id: 1,
  #       type: 'meeting'
  #     }
  #
  # Now, since commentable is not really an association, it needs to delegate
  # those values to proper relationship. Radium.Serializer deals with it and
  # when it materializes a record (`materializeFromData` method), it automatically
  # picks up appropriate relationship (meeting in this case) and sets meeting_id
  # to 1. Note that since it needs the relationship, you will have to define all
  # associations needed, for example:
  #
  #     todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'commentable')
  #     meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'commentable')
  #
  # When you try to fetch `commentable`, it goes through all associations defined
  # for commentable and (todo and meeting in this case) and picks up first one that
  # is not null.
  #
  # When you set commentable, for example:
  #
  #     comment.set 'commentable', todo
  #
  # It will clear all associations defined for commentable and set the proper one
  # to given object. In the above example, it would clear the meeting association
  # and set todo, just like you would call
  #
  #     comment.set 'todo', todo
  #
  # Although it works perfectly fine with fixtures, serialization to JSON does not
  # take into account commentable yet - in order to work properly it should find
  # currently active commentable association and set proper commentable key. It's
  # easy to implement and I'm skipping it for now, because maybe at the time API
  # is needed, Ember has its own proper solution to the problem.
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
