describe("Radium#Person", function() {

  it("inherits from Radium#Core", function() {
    expect(Radium.Core.detect(Radium.Person)).toBeTruthy();
  });
  
  it("should extract first name", function() {
    var person = Radium.Person.create({
      name: 'Spiros Vondos Vondopoulos'
    });
    expect(person.get('firstName')).toEqual("Spiros");
  });

  it("should extract an intialed last name", function() {
    var person = Radium.Person.create({
      name: 'Spiros Vondos Vondopoulos'
    });
    
    expect(person.get('abbrName')).toEqual("Spiros V.");
  });

  it("should extract a name that contains middle name", function() {
    var longPersonName = Radium.Person.create({
      name: 'Joshua Ray Jones-Hoefler'
    });
    expect(longPersonName.get('abbrName')).toEqual("Joshua J.");
  });

  it("should skip an abbreviation if the name is only 1 word long", function() {
    var firstNameOnly = Radium.Person.create({
      name: "Bubbles"
    });
    expect(firstNameOnly.get('firstName')).toEqual("Bubbles");
    expect(firstNameOnly.get('abbrName')).toEqual("Bubbles");
  });
});