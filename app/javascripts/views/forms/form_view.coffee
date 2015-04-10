Radium.FormView = Radium.View.extend Radium.FlashNewViewMixin,
  isNew: Ember.computed.oneWay 'controller.isNew'
  isExpandable: Ember.computed.oneWay 'controller.isExpandable'
  isExpanded: Ember.computed.alias 'controller.isExpanded'

  didInsertElement: ->
    @_super.apply this, arguments

    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on

    @$('.expander').on 'click', (e) =>
      return if ["A", "I"].contains e.target.tagName
      return if e.target.tagName == "TEXTAREA" && @get('isExpanded')
      return unless @get('isExpandable')
      @toggleProperty 'isExpanded'

      false

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    controller = @get('controller')
    controller.off('formReset', this, 'onFormReset') if controller.evented

    @$('.exapnder').off 'click'
