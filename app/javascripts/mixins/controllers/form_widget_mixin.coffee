Radium.FormWidgetMixin = Ember.Mixin.create
  activeForm: null

  init: ->
    @get('buttons').forEach (btn) -> btn.set('closed', true)

  toggleForm: (button)  ->
    if @get('activeTemplate') && @get('activeTemplate') == button.template
      @set 'activeTemplate', null
      @send 'bulkFormClosed'
    else
      @set 'activeTemplate', null
      # FIXME: remove runloop next
      Ember.run.next =>
        @send 'bulkFormOpen', button.name
        @set 'activeTemplate', button.template
