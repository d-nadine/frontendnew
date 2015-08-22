Radium.ListsPersistenceMixin = Ember.Mixin.create
  actions:
    addList: (resource, list) ->
      return if resource.get('lists').toArray().contains list

      record = Radium.AddList.createRecord
                 contact: resource
                 list: list

        record.save()

      false

    removeList: (resource, list) ->
      return unless resource.get('lists').toArray().contains list


      record = Radium.RemoveList.createRecord
                 contact: resource
                 list: list

      record.save()

      false

  # UPGRADE: replace with inject
  lists: Ember.computed ->
    @container.lookup('controller:lists').get('sortedLists')
