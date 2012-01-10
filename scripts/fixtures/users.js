define('fixtures/users', function(require) {
  
  require('models/user');
  
  Radium.User.FIXTURES = [
    {
      id: 1,
      name: "Jimmy McNulty",
      contacts: [101, 102, 103]
    },
    {
      id: 2,
      name: "Cedric Daniels",
      contacts: [108]
    },
    {
      id: 3,
      name: "Kimma Greggs",
      contacts: [109]
    },
    {
      id: 4,
      name: "Bunk Moreland",
      contacts: [105]
    },
    {
      id: 5,
      name: "Lester Freamon",
      contacts: [104]
    },
    {
      id: 6,
      name: "Thomas Hauk",
      contacts: [106]
    },
    {
      id: 7,
      name: "Ellis Carver",
      contacts: [107]
    }
  ];
  
});