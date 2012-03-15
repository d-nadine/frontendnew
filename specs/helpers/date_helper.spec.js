describe("Handlebars helpers", function() {
  
  describe("Date Helper", function() {
    var view, fixture;
    beforeEach(function() {
      fixture = $('<div/>');
      view = Ember.View.create({
        myDate: new Date('2012-04-21T18:28:42Z'),
        template: Ember.Handlebars.compile('<h1>{{formatDate myDate format="%B %D, %Y"}}</h1>')
      });
    });

    afterEach(function() {
      view.destroy();
    });

    it("parses a date object into a string", function() {
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('April 21, 2012');
    });

    it("defaults to \"%B %D, %Y\" if no format option is passed", function() {
      view.set('template', Ember.Handlebars.compile('<h1>{{formatDate myDate}}'));
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('April 21, 2012');
    });

    it("updates when observers fire", function() {
      var newDate = Ember.DateTime.create().toFormattedString("%B %D, %Y");
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('April 21, 2012');
      Ember.run(function() {view.set('myDate', new Date());});
      expect(fixture.find('h1').text()).toEqual(newDate);
    });

    it("updates when recieving a date after being added to the DOM", function() {
      view.set('myDate', null);
      var newDate = Ember.DateTime.create().toFormattedString("%B %D, %Y");
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual("");
      Ember.run(function() {view.set('myDate', new Date());});
      expect(fixture.find('h1').text()).toEqual(newDate);
    });

    it("removes observers", function() {
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').length).toEqual(1);
      view.remove();
      expect(fixture.find('h1').length).toEqual(0);
    });
  });
});