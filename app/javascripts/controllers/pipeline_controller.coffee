Radium.PipelineController = Em.Controller.extend
  leads: (->
    Radium.Contact.filter((contact) ->
      contact.get('status') is 'lead'
    )
  ).property()

  negotiating: (->
    Radium.Deal.filter((deal) ->
      deal.get('status') is 'negotiating'
    )
  ).property()

  closed: (->
    Radium.Deal.filter((deal) ->
      deal.get('status') is 'closed'
    )
  ).property()

  lost: (->
    Radium.Deal.filter((contact) ->
      contact.get('status') is 'lost'
    )
  ).property()
