# Hacks because ember does not provide away
# to do this right now. Current use case is 
# disconnecting the drawer whenever changing
# states
Ember.Router.reopen
  didTransition: ->
    @send 'didTransition'
    @_super.apply this, arguments

