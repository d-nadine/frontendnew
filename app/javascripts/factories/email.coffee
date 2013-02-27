Factory.define 'email', traits: ['timestamps', 'html'],
  subject: Factory.sequence (i) -> "Email #{i}"
  sentAt: -> Ember.DateTime.random past: true
  message: """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. In a tempus
    felis. Maecenas lacinia risus pellentesque ipsum vehicula convallis.
    Aenean lobortis erat in felis semper quis posuere sapien fermentum.
    Suspendisse metus tellus, sodales a ultrices ut, mattis vitae erat. Duis
    leo felis, sollicitudin sed tristique sed, facilisis et turpis. Morbi
    pulvinar odio id felis sollicitudin sed accumsan justo luctus. Duis
    volutpat, velit vestibulum dignissim sagittis, purus massa dignissim
    erat, vitae tincidunt velit leo vel elit. Aenean euismod, nibh et
    tincidunt consequat, nibh purus tristique libero, ut sodales sem felis
    lobortis sapien. Suspendisse sed lectus erat. Pellentesque at justo
    lectus. Aliquam augue odio, volutpat a pharetra eget, bibendum at est.
    In hac habitasse platea dictumst. Phasellus vel mi vel leo adipiscing
    dapibus vel auctor mauris.
  """
  sender: ->
    if Math.random() <= 0.5
      Factory.create 'user'
    else
      Factory.create 'contact'

  attachments: -> [
    Factory.create 'attachment'
    Factory.create 'attachment'
    Factory.create 'attachment'
  ]

  isPublic: true
