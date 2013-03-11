Radium.PipelineViewBase = Ember.View.extend
  bulkLeader: ( ->
    form = @get('controller.activeForm')
    return unless form

    length = @get('controller.checkedContent.length')

    prefix =
      switch form
        when "todo" then "ADD A TODO ABOUT  "
        when "call" then "CREATE AND ASSIGN A CALL FROM  "
        else
          throw new Error("Unknown #{form} for bulkLeader")

    if length == 1
      "#{prefix} THIS LEAD."
    else
      "#{prefix} #{@get('controller.checkedContent.length')} SELECTED LEADS."
  ).property('controller.activeForm', 'controller.checkedContent.length')
