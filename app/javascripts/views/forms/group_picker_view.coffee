require 'views/forms/picker_view'
Radium.FormsGroupPickerView = Radium.FormsPickerView.extend
  nameBinding: 'nameToGroupTransform'
  leader: "location"
  listBinding: 'controller.groups'

    # FIXME: make this async
  source: (query, process) ->
    Radium.Group.all().map((c) -> c.get('name')).toArray()
