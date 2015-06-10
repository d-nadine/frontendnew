Radium.FormView = Radium.View.extend Radium.FlashNewViewMixin,
  isNew: Ember.computed.oneWay 'controller.isNew'
  isExpandable: Ember.computed.oneWay 'controller.isExpandable'
  isExpanded: Ember.computed.alias 'controller.isExpanded'

  didInsertElement: ->
    @_super.apply this, arguments

    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on

    @$('.form').on 'click', (e) =>
      tagName = e.target.tagName
      target = $(e.target)
      return if tagName != 'TEXTAREA' && !target.hasClass('expander') && !target.hasClass('topic')

      return if tagName == 'TEXTAREA' && @get('isExpanded')
      @toggleProperty 'isExpanded'

      Ember.run.next =>
        @$('TEXTAREA:first')?.setCursorPosition()

      false

  teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    controller = @get('controller')
    controller.off('formReset', this, 'onFormReset') if controller.evented

    @$('.exapnder').off 'click'
