Radium.Filter = Ember.Object.extend
  icon: (->
    "icon-#{@get('type').dasherize()}"
  ).property('type')

Radium.Filters = 
  everything: Radium.Filter.create
    label: 'Everything'
    type: 'all'
  todos: Radium.Filter.create
    label: 'Todos'
    type: 'todo'
  meetings: Radium.Filter.create
    label: 'Meetings'
    type: 'meeting'
  deals: Radium.Filter.create
    label: 'Deals'
    type: 'deal'
