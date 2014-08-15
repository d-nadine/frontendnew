Radium.FormsCompanyView = Radium.View.extend
  classNames: ['new-company']
  actions:
    showExisting: ->
      @$('.existing-company').slideDown('medium')

    resetCompany: ->
      @get('controller').send 'reset'
      Ember.run.later =>
        @$('input[type=text]').focus()
      , 500

  willDestroyElement: ->
    @get('controller').send 'reset'
    @_super.apply this, arguments

  companyPicker: Radium.ContactCompanyPicker.extend
    classNameBindings: [':field', 'isInvalid']
    placeholder: 'Add Company'
    disabled: Ember.computed.alias 'controller.isDisabled'

    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.companyName', ->
      return unless @get('controller.isSubmitted')
      value = @get('controller.companyName')
      !value || value.length == 0

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
