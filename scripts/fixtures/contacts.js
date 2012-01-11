define('fixtures/contacts', function(require) {
  var Radium = require('radium');
  require('models/contact');
  
  Radium.Contact.FIXTURES = [
    {
      id: 101,
      name: "Stringer Bell",
      user: 1
    },
    {
      id: 102,
      name: "Avon Barksdale",
      user: 1
    },
    {
      id: 103,
      name: "Bodie Broadus",
      user: 1
    },
    {
      id: 104,
      name: "Marlo Stanfield",
      user: 5
    },
    {
      id: 105,
      name: "D'Angelo Barksdale",
      user: 4
    },
    {
      id: 106,
      name: "Chris Partlow",
      user: 6
    },
    {
      id: 107,
      name: "Snoop Pearson",
      user: 7
    },
    {      
      id: 108,
      name: "Michael Lee",
      user: 2
    },
    {
      id: 109,
      name: "Bubbles",
      user: 3
    }
  ];
  
  return Radium;
});