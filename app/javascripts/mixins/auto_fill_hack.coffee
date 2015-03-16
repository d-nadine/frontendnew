Radium.AutoFillHackMixin = Ember.Mixin.create
  autoFillHack: Ember.on 'didInsertElement', ->
    el = @autocompleteElement()
    Ember.run.next ->
      el.get(0).removeAttribute('disabled')
