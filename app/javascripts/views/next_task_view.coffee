Radium.NextTaskView = Radium.View.extend
  setup: Ember.on 'didInsertElement', ->
    if @get('controller.isTodo')
      title = @get('controller.description')

    if @get('controller.isMeeting')
      title = @get('controller.topic')

    if title
      @$('a').tooltip(
        title: title
      )

  teardown: Ember.on 'willDestroyElement', ->
    if @$('a').data('tooltip')
      @$('a').tooltip('destroy')
