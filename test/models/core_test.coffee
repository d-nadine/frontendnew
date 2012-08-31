module 'Radium.Core'

test 'it returns type', ->
  Radium.SomeModel = Radium.Core.extend()
  record = Radium.store.createRecord(Radium.SomeModel, {})
  equal record.get('type'), 'some_model', 'Radium.SomeModel#type should == some_model'

test '.root() returns last superclass before core', ->
  Radium.SomeModel = Radium.Core.extend()
  Radium.SomeSubModel = Radium.SomeModel.extend()

  equal Radium.SomeModel.root(), Radium.SomeModel, ''
  equal Radium.SomeSubModel.root(), Radium.SomeModel, ''
