Radium.FormsCompanyView = Radium.View.extend
  classNames: ['new-company', 'hide']
  actions:
    hideNewCompany: ->
      @$().slideUp('slow', =>
        Ember.$('.address-book-controls').slideDown('medium'))

    showExisting: ->
      @$('.existing-company').slideDown('medium')

    resetCompany: ->
      @$('.existing-company').slideDown('medium', =>
        @get('controller').send 'reset'
        Ember.run.later =>
          @$('input[type=text]').focus()
        , 500
      )

  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('setupNewCompany', this, 'onSetupNewCompany')

  willDestroyElement: ->
    @send 'hideNewCompany'
    @_super.apply this, arguments
    @get('controller').off('setupNewCompany', this, 'onSetupNewCompany')

  onSetupNewCompany: ->
    console.log 'do we need this'

  companyPicker: Radium.ContactCompanyPicker.extend
    classNameBindings: [':field', 'isInvalid']
    placeholder: 'Company'
    disabled: Ember.computed.alias 'controller.isDisabled'

    isInvalid: ( ->
      return unless @get('controller.isSubmitted')
      value = @get('controller.companyName')
      !value || value.length == 0
    ).property('controller.isSubmitted', 'controller.companyName')

    setValue: (obj) ->
      @_super obj.get('person')
      @get('parentView').send 'showExisting'

    keyDown: (e) ->
      unless e.keyCode == 13
        @_super.apply this, arguments
        return

      @get('controller').send 'createCompany'
      e.preventDefault()
      e.stopPropagation()
      false
