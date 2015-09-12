require 'views/pipeline/pipeline_base_view'

Radium.PipelineIndexView = Radium.PipelineViewBase.extend Radium.ScrollTopMixin,
  showResults: true
  toggleResultsTable: (evt) ->
    @$('.table.totals').slideToggle('medium')
    @toggleProperty 'showResults'

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    tick = Ember.run.later ->
      el = $('.pipeline-search input[type=text]')
      p el
      el.val('').focus()
      Ember.run.cancel tick
    , 1000
