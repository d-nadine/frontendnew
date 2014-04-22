Radium.FormView = Radium.View.extend Radium.FlashNewViewMixin,
  didInsertElement: ->
    @_super.apply this, arguments

    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on
