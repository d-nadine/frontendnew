describe("Radium#feedController", function() {
  var adapter, store, server, spy;

  beforeEach(function() {
    adapter = RadiumAdapter.create();
    store = DS.Store.create({revision: 2, adapter: adapter});
    server = sinon.fakeServer.create();
    spy = sinon.spy(jQuery, 'ajax');
  });

  afterEach(function() {
    adapter.destroy();
    store.destroy();
    server.restore();
    jQuery.ajax.restore();
  });

  // it("loads activities", function() {
  //   console.log(Radium.feedController.get('sorted'));
  // });

  // it("maps days", function() {
  //   expect(Radium.feedController.get('days'))
  //     .toEqual(['2012-12', '2012-25', '2012-08', '2012-30', '2012-17', '2011-24']);
  // });

  // it("maps weeks", function() {
  //   expect(Radium.feedController.get('days'))
  //     .toEqual([ '2012-12', '2012-25', '2012-08', '2012-30', '2012-17', '2011-24']);
  // });

  // it("maps months", function() {
  //   expect(Radium.feedController.get('months'))
  //     .toEqual(['2012-09', '2012-10', '2012-11', '2012-12', '2011-12']);
  // });

  // it("maps quarters", function() {
  //   expect(Radium.feedController.get('quarters'))
  //     .toEqual(['2012-Q3', '2012-Q4', '2011-Q4']);
  // });

  // it("maps years", function() {
  //   expect(Radium.feedController.get('years')).toEqual(['2012', '2011']);
  // });
});