module 'Radium.Core'

test 'it returns type', ->
  Radium.SomeModel = Radium.Core.extend()
  record = Radium.store.createRecord(Radium.SomeModel, {})
  equal record.get('type'), 'some_model', 'Radium.SomeModel#type should == some_model'
