Radium.ChangeDealStatusMixin = Ember.Mixin.create
  actions:
    changeStatus: (status) ->
      @discardBufferedChanges()

      return if status == @get('status')

      commit =  =>
        if status == 'lost'
          @set 'lostDuring', @get('model.status')

        @applyBufferedChanges()

        @get('model').one 'didUpdate', =>
          @get('controllers.contact')?.notifyPropertyChange('dealsTotal')

        @get('store').commit()

      @set 'status', status
      @send 'showStatusChangeConfirm', this, commit

  needs: ['contact']
