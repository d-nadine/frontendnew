define('testdir/models/person.spec', function(require) {
  var Person = require('models/person');
  
  describe("Person Class", function() {

    beforeEach(function() {
      this.person = Person.create({
        id: 1,
        created_at: "2011-05-04T12:03:47Z",
        updated_at: "2011-05-04T12:03:47Z",
        name: 'Spiros Vondos Vondopoulos'
      });

      this.longpersonname = Person.create({
        id: 2,
        created_at: "2011-05-04T12:03:47Z",
        updated_at: "2011-05-04T12:03:47Z",
        name: 'Joshua Ray Jones-Hoefler'
      });
    });

    afterEach(function() {
      this.person.destroy();
      this.longpersonname.destroy();
    });

    it("should extract first name", function() {
      expect(this.person.get('firstName')).toEqual("Spiros");
    });

    it("should extract an intialed last name", function() {
      expect(this.person.get('abbrName')).toEqual("Spiros V.");
    });

    it("should extract a name that contains middle name", function() {
      expect(this.longpersonname.get('abbrName')).toEqual("Joshua J.");
    });

  });
});