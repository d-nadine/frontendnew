Radium.LeadStatusesController = Ember.ArrayProxy.extend
  content: [
    { name: "None", value: "none" }
    { name: "Lead", value: "lead" }
    { name: "Existing Customer", value: "existing" }
    { name: "Exclude From Pipeline", value: "exclude" }
  ]

  statuses: ( ->
    return unless @get('content').length

    @get('content').map (status) ->
      Ember.Object.create
        name: status.name.toUpperCase()
        value: status.value
  ).property('model.[]')

