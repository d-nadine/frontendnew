Radium.NextTaskView = Radium.View.extend
  didInsertElement: ->
    if @get('controller.isTodo')
      title = @get('controller.description')

    if @get('controller.isCall')
      title = @get('controller.reference.name')

    if @get('controller.isMeeting')
      title = @get('controller.topic')

    if title
      @$('a').tooltip(
        title: title
      )

  willDestroyElement: ->
    if @$('a').data('tooltip')
      @$('a').tooltip('destroy')