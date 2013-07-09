Radium.LeadStatusesController = Ember.ArrayProxy.extend
  content: [
    { name: "Pipeline", value: "pipeline" }
    { name: "Exclude From Pipeline", value: "exclude" }
    { name: "Personal", value: "personal" }
  ]

  statuses: ( ->
    return unless @get('content').length

    @get('content').map (status) ->
      Ember.Object.create
        name: status.name.toUpperCase()
        value: status.value
  ).property('model.[]')
