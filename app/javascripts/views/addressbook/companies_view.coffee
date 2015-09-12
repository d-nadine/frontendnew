Radium.AddressbookCompaniesView = Radium.View.extend
  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    tick = Ember.run.later ->
      el = $('.col-selector input[type=text]')
      el.focus()
      Ember.run.cancel tick
    , 2000
