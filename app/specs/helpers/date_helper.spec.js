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

    // it("outputs a formatted DateTime object day", function() {
    //   view.set('type', 'day');
    //   Ember.run(function() {view.appendTo(fixture);});
    //   expect(fixture.find('h1').text()).toEqual('February 3, 2012');
    // });

    // it("outputs a formatted DateTime object week", function() {
    //   view.set('type', 'week');
    //   Ember.run(function() {view.appendTo(fixture);});
    //   expect(fixture.find('h1').text()).toEqual('Week 05, 2012');
    // });

    // it("outputs a formatted DateTime object month", function() {
    //   view.set('type', 'month');
    //   Ember.run(function() {view.appendTo(fixture);});
    //   expect(fixture.find('h1').text()).toEqual('February 2012');
    // });
    
    // it("outputs a formatted DateTime object quarter", function() {
    //   view.set('type', 'quarter');
    //   Ember.run(function() {view.appendTo(fixture);});
    //   expect(fixture.find('h1').text()).toEqual('1st Quarter, 2012');
    // });
    
    // it("outputs a formatted DateTime object year", function() {
    //   view.set('type', 'year');
    //   Ember.run(function() {view.appendTo(fixture);});
    //   expect(fixture.find('h1').text()).toEqual('2012');
    // });
  });
});