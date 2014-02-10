Radium.ChangeDealStatusMixin = Ember.Mixin.create
  actions:
    changeStatus: (status) ->
      @discardBufferedChanges()

      return if status == @get('status')

      commit =  =>
        @set 'status', status

        if status == 'lost'
          @set 'lostDuring', @get('model.status')
        @applyBufferedChanges()
        @get('store').commit()

      @send 'showStatusChangeConfirm', this, commit


