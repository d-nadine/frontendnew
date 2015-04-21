Radium.ChangeDealStatusMixin = Ember.Mixin.create
  actions:
    changeStatus: (status) ->
      @discardBufferedChanges()

      return if status == @get('status')

      commit =  =>
        if status == 'lost'
          @set 'lostDuring', @get('model.status')

        @applyBufferedChanges()

        @get('model').save(this).then =>
          @get('controllers.contact')?.notifyPropertyChange('dealsTotal')

      @set 'status', status
      @send 'showStatusChangeConfirm', this, commit

  needs: ['contact']
