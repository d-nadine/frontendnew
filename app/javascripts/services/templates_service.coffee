Radium.TemplatesService = Ember.Object.extend
  refresh: ->
    Radium.Template.find({}).then (results) =>
      @set 'templates', results

      @notifyPropertyChange 'templates'

  _initialize: Ember.on 'init', ->
    @set 'templates', Ember.A()