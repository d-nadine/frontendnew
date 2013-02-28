require 'views/forms/picker_view'
Radium.FormsUserPickerView = Radium.FormsPickerView.extend
  classNameBindings: [
    'user:is-valid'
    'isInvalid'
  ]

  leader: "Assigned To"
  userBinding: 'controller.user'
  nameBinding: 'nameToUserTransform'
  listBinding: 'controller.users'

  nameToUserTransform: ((key, value) ->
    if arguments.length == 2
      result = Radium.User.all().find (user) =>
        user.get('name') is value
      @set 'user', result
    else if !value && @get('user')
      @get 'user.name'
    else
      value
  ).property()

  # FIXME: make this async
  source: (query, process) ->
    Radium.User.all().map((c) -> c.get('name')).toArray()
