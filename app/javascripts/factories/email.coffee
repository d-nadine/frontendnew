Factory.define 'email', traits: 'timestamps',
  subject: Factory.sequence (i) -> "Email #{i}"
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
  sender:
    id: -> Factory.build 'user'
    type: 'user'
