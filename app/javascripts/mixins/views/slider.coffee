Radium.Slider = Ember.Mixin.create
  slideUp: (cb) ->
    self = this
    callback = cb || (-> self.remove() )
    $.when(@$().slideUp('fast')).then(callback)
  didInsertElement: ->
    @$().hide().slideDown('fast')
    @_super()
