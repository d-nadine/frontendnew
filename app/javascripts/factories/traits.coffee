Factory.trait 'timestamps',
  createdAt: -> Ember.DateTime.create().advance(days: -2).toFullFormat()
  updatedAt: -> Ember.DateTime.create().advance(days: -1).toFullFormat()

Factory.trait 'avatar',
  avatar:
    small_url: '/images/fallback/small_default.png'
    medium_url: '/images/fallback/medium_default.png'
    large_url: '/images/fallback/large_default.png'
    huge_url: '/images/fallback/huge_default.png'

Factory.trait 'html',
  html: "<p>Lorem ipsum <strong>dolor sit amet</strong>, consectetur adipiscing elit. Fusce in
    eros ante. Donec pellentesque pulvinar arcu nec eleifend. Nulla nulla diam,
    dignissim in bibendum vitae, viverra et quam. Nam vulputate convallis
    dapibus. Duis purus leo, posuere in tristique eget, <i>elementum at metus</i>. In
    ut purus urna, id ornare nibh. Phasellus eros libero, imperdiet a faucibus
    sed, varius sit amet velit. Praesent purus massa, consequat vel eleifend a,
    laoreet eu orci. Vestibulum imperdiet lobortis felis vitae iaculis.
    Vivamus at velit orci. Quisque justo diam, condimentum eget cursus in,
    semper vitae mauris. Donec id ullamcorper mauris. Fusce sit amet velit
    nisl, eleifend ullamcorper metus. Pellentesque condimentum felis sed erat
    varius ultricies. Class aptent taciti sociosqu ad litora torquent per
    conubia nostra, per inceptos himenaeos. Nulla eu neque sed lacus
    consectetur ornare eu a turpis.</p>"

Factory.trait 'message',
  sentAt: -> Ember.DateTime.create().toFullFormat()
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
