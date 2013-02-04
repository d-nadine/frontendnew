FormButton = Ember.Object.extend
  bulk: ->
    template = @get 'template'
    parts = template.split '/'
    new_template = "#{parts[0]}/bulk_#{parts[1]}"
    set 'template', new_template


Radium.FormButtons = {
  deleteAll: Ember.Object.create
    action: "deleteAll"
    title: "Delete"
    alwaysOpen: true
    classes: 'btn btn-danger'
    icons: 'icon-trash icon-large icon-white'
  todo: Ember.Object.create
    template: "forms/bulk_todo_form"
    title: "Todo"
  meeting: Ember.Object.create
    template: "unimplemented"
    title: "Meeting"
  call: Ember.Object.create
    template: "unimplemented"
    title: "Call"
  email: Ember.Object.create
    template: "unimplemented"
    title: "Email"
}
