define('testdir/models/person.spec', function(require) {
  var Person = require('models/person');
  
  describe("Radium#Person", function() {

    beforeEach(function() {
      this.person = Radium.Person.create({
        id: 1,
        created_at: "2011-05-04T12:03:47Z",
        updated_at: "2011-05-04T12:03:47Z",
        name: 'Spiros Vondos Vondopoulos'
      });

      this.longpersonname = Radium.Person.create({
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

    it("inherits from Radium#Core", function() {
      expect(Radium.Core.detect(Radium.Person)).toBeTruthy();
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