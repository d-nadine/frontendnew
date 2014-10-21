Radium.ThreadItemView = Radium.View.extend
  emailsThread: Ember.computed.alias 'controller.controllers.emailsThread'

  setup: (->
    @get('controller').on('contentLoaded', this, 'scrollToFirstEmail')
  ).on 'didInsertElement'

  scrollToFirstEmail: ->
    # scroll to last email
    parentController = @get('controller.controllers.emailsThread')

    return if parentController.get('initialised')

    currentPage = parentController.get('page')
    isLast = !!(@get('controller.model') == parentController.get('lastObject'))
    isFirstPage = !!(currentPage == 1)

    if isFirstPage && isLast
      Ember.run.next =>
        selector = ".email-history [data-id='#{@get('controller.model.id')}']"
        ele = $(selector).get(0)
        Ember.$.scrollTo("##{ele.id}", 0, {offset: -100})
        parentController.set 'initialised', true
