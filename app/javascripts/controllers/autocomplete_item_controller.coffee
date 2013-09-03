Radium.AutocompleteItemController = Radium.ObjectController.extend
  displayName: ( ->
    model = @get('model')
    return model.get('displayName') if model.get('displayName.length')
    return model.get('name') if model.get('name.length')
    model.get('email')
  ).property('model')
