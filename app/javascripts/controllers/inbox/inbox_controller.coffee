Radium.InboxController = Em.ArrayController.extend
  selectedMail: ( ->
    @filter (email) -> email.get('isSelected')
  ).property('@each.isSelected')
  deselectEmail: (event) ->
    event.context.set('isSelected', false)

