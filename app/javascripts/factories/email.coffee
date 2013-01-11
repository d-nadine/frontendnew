Factory.define 'email', traits: ['timestamps', 'html'],
  subject: Factory.sequence (i) -> "Email #{i}"
<<<<<<< HEAD
  sent_at: -> Ember.DateTime.create().toFullFormat()
  message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce in
    eros ante. Donec pellentesque pulvinar arcu nec eleifend. Nulla nulla diam,
    dignissim in bibendum vitae, viverra et quam. Nam vulputate convallis
    dapibus. Duis purus leo, posuere in tristique eget, elementum at metus. In
    ut purus urna, id ornare nibh. Phasellus eros libero, imperdiet a faucibus
    sed, varius sit amet velit. Praesent purus massa, consequat vel eleifend a,
    laoreet eu orci. Vestibulum imperdiet lobortis felis vitae iaculis.
    Vivamus at velit orci. Quisque justo diam, condimentum eget cursus in,
    semper vitae mauris. Donec id ullamcorper mauris. Fusce sit amet velit
    nisl, eleifend ullamcorper metus. Pellentesque condimentum felis sed erat
    varius ultricies. Class aptent taciti sociosqu ad litora torquent per
    conubia nostra, per inceptos himenaeos. Nulla eu neque sed lacus
    consectetur ornare eu a turpis."
=======
  sent_at: Ember.DateTime.create().toFullFormat()
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
>>>>>>> Email listing view
  sender:
    id: -> Factory.build 'user'
    type: 'user'
  attachments: -> [
    Factory.create 'attachment'
    Factory.create 'attachment'
    Factory.create 'attachment'
  ]
  comments: -> [
    Factory.create 'comment'
  ]
