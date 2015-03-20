Radium.FormsCompanyView = Radium.View.extend
  classNames: ['new-company', 'hide']
  actions:
    showExisting: ->
      @$('.existing-company').slideDown('medium')

    hideNewCompany: ->
      if @get('controller.company')
        return @send 'resetCompany'

      @$().slideUp('slow', ->
        Ember.$('.address-book-controls').slideDown('medium'))

    resetCompany: ->
      @get('controller').send 'reset'
      Ember.run.later =>
        @$('input[type=text]').val('').focus()
      , 500

  setup: Ember.on 'didInsertElement', ->
    @get('controller').on('formReset', this, 'onFormReset')
    @get('controller').on('modelChanged', this, 'onModelChanged')

  onModelChanged: ->
    @send 'showExisting'

  onFormReset: ->
    @send 'resetCompany'

  willDestroyElement: ->
    controller = @get('controller')
    controller.off 'formReset'
    controller.off 'modelChanged'
    @_super.apply this, arguments
