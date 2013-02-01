Radium.PipelineController = Em.Controller.extend
  leads: (->
    Radium.Contact.filter((contact) -> 
      contact.get('status') is 'lead'
    ).get('length')
  ).property()

  negotiating: (->
    Radium.Deal.filter((deal) -> 
      deal.get('status') is 'negotiating'
    ).get('length')
  ).property()

  closed: (->
    Radium.Deal.filter((deal) -> 
      deal.get('status') is 'closed'
    ).get('length')
  ).property()

  lost: (->
    Radium.Contact.filter((contact) -> 
      contact.get('status') is 'lost'
    ).get('length')
  ).property()
