describe("Radium#ContactLabelView", function() {
  var view, fixture, contact, store;

  beforeEach(function() {
    store = DS.Store.create({revision: 3});

    fixture = $('<div/>');

    store.load(Radium.Contact, {
      id: 1,
      status: 'prospect'
    });
    
    contact = Ember.Object.create({
      content: store.find(Radium.Contact, 1)
    });
    console.log('asdf', contact.getPath('content.status'));

    view = Radium.ContactLabelView.create({
      status: 'prospect'
    });
    
  });

  afterEach(function() {
    store.destroy();
    contact.destroy();
    view.destroy();
  });

  it("applies the correct class name", function() {
    Ember.run(function() {view.appendTo(fixture);});
    expect(fixture.find('span').hasClass('label-warning')).toBeTruthy();
  });

  it("converts the status key into a clean, grammatical string", function() {
    view.set('status', 'dead_end');
    Ember.run(function() {view.appendTo(fixture);});
    expect(fixture.find('span').text()).toEqual('Dead End');
  });

});