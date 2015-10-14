Radium.ListsPersistenceMixin = Ember.Mixin.create
  actions:
    addList: (resource, list) ->
      return if resource.get('lists').toArray().contains list

      unless list.constructor is Radium.List
        Ember.assert "You must include the Radium.CommonModals mixin to create a new list", @_actions['createList']

        return @send 'createList', list

      unless resource instanceof Radium.Model
        return resource.get('lists').pushObject list

      record = Radium.AddList.createRecord
                 reference: resource
                 list: list

        record.save().then =>
          @get('peopleController').send 'updateTotals'

      false

    removeList: (resource, list) ->
      return unless resource.get('lists').toArray().contains list

      record = Radium.RemoveList.createRecord
                 reference: resource
                 list: list

      record.save().then =>
        @get('peopleController').send 'updateTotals'

      false

  # UPGRADE: use inject after upgrade
  peopleController: Ember.computed ->
    @container.lookup('controller:peopleIndex')
