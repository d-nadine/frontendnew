Radium.EmailsShowView = Radium.View.extend didInsertElement: ->
    model = @get 'controller.model'

    return if model == @get('controller.history.firstObject')

    Ember.run.next =>
      modelSelector = "[data-model='#{model.constructor}'][data-id='#{model.get('id')}']"

      emailCard = Ember.$(modelSelector)

      return unless emailCard.length

      mainRow = Ember.$('.two-column-layout')

      topOfMainColumn = emailCard.offset().top - mainRow.offset().top

      $.scrollTo topOfMainColumn
