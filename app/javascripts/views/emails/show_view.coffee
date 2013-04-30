Radium.EmailsShowView = Radium.View.extend
  didInsertElement: ->
    model = @get 'controller.model'

    return if model == @get('controller.history.firstObject')

    Ember.run.next =>
      modelSelector = "[data-model='#{model.constructor}'][data-id='#{model.get('id')}']"

      emailCard = @$(modelSelector)
      mainRow = $('.main-row')

      topOfMainColumn = emailCard.offset().top - mainRow.offset().top

      if @$('.hud').length != 0
        topOfMainColumn = topOfMainColumn - @$('.hud').height()

      $.scrollTo topOfMainColumn
