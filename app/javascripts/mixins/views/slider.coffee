Radium.Slider = Ember.Mixin.create
  slideUp: (cb) ->
    return unless @$()

    self = this
    callback = cb || (-> self.remove() )
    $.when(@$().slideUp('fast')).then(callback)
  didInsertElement: ->
    @$().hide().slideDown('fast')
    @_super()
