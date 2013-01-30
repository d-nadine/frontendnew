Radium.FormWidgetMixin = Ember.Mixin.create
  activeForm: null

  init: ->
    @get('buttons').forEach (btn) -> btn.set('closed', true)

  toggleForm: (button)  ->
    if @get('activeForm') && @get('activeForm') == button.template
      @set 'activeForm', null
    else
      @set 'activeForm', null
      # FIXME: remove runloop next
      Ember.run.next =>
        @set 'activeForm', button.template
