Radium.Serializer = DS.RESTSerializer # this is an instance, should probably be class

for name, transform of Radium.transforms
  Radium.Serializer.registerTransform name, transform
