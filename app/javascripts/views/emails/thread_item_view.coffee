Radium.ThreadItemView = Radium.View.extend
  selectedEmail: Ember.computed.oneWay 'controller.selectedEmail'
  currentEmail: Ember.computed.oneWay 'controller.model'
  hasScrolled: Ember.computed.alias 'parentView.hasScrolled'

  setup: ( ->
    Ember.run.scheduleOnce 'afterRender', this, =>
      return if @get('hasScrolled')
      return unless @get('selectedEmail') == @get('currentEmail')

      selector = "##{@$().get(0).id}"

      Ember.$.scrollTo(selector, 800, {offset: -100})

      @set 'hasScrolled', true
  ).on('didInsertElement')
