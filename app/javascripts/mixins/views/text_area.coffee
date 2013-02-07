Radium.TextAreaMixin = Ember.Mixin.create(Ember.TargetActionSupport,
  didInsertElement: ->
    @_super()
    @$().autosize().css('resize','none')

  willDestroyElement: ->
    $('html').off('click.autoresize')

  click: (event) ->
    event.stopPropagation()

  insertNewline: ->
    @triggerAction()
)

