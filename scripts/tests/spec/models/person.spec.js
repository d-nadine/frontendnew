define('testdir/models/person.spec', function(require) {
  var Person = require('models/person');
  
  describe("Radium#Person", function() {

    beforeEach(function() {
      this.person = Radium.Person.create({
        id: 1,
        name: 'Spiros Vondos Vondopoulos'
      });

      this.longpersonname = Radium.Person.create({
        id: 2,
        name: 'Joshua Ray Jones-Hoefler'
      });
      
      this.firstnameonly = Radium.Person.create({
        id: 3,
        name: "Bubbles"
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

    it("should skip an abbreviation if the name is only 1 word long", function() {
      expect(this.firstnameonly.get('firstName')).toEqual("Bubbles");
      expect(this.firstnameonly.get('abbrName')).toEqual("Bubbles");
    });
  });
});